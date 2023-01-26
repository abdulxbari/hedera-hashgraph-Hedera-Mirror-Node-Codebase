package com.hedera.mirror.importer.parser.record;

/*-
 * ‌
 * Hedera Mirror Node
 * ​
 * Copyright (C) 2019 - 2022 Hedera Hashgraph, LLC
 * ​
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ‍
 */

import static org.junit.jupiter.api.Assertions.*;

import java.time.Instant;
import java.util.concurrent.TimeUnit;

import com.google.common.util.concurrent.Uninterruptibles;
import com.hedera.mirror.common.domain.DomainBuilder;
import com.hedera.mirror.common.domain.StreamType;
import com.hedera.mirror.importer.config.IntegrationTestConfiguration;
import com.hedera.mirror.importer.parser.domain.RecordFileBuilder;
import lombok.RequiredArgsConstructor;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;

@ActiveProfiles({"performance", "v2"})
@Import(IntegrationTestConfiguration.class)
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
@SpringBootTest
@Tag("performance")
class RecordFileParserPerformanceTest {

    private final ParserPerformanceProperties performanceProperties;
    private final RecordFileParser recordFileParser;
    private final RecordFileBuilder recordFileBuilder;
    private final DomainBuilder domainBuilder;

    @Test
    void scenarios() {
        long interval = StreamType.RECORD.getFileCloseInterval().toMillis();
        long endTime = System.currentTimeMillis();
        var startDate = performanceProperties.getStartDate();
        var endDate = performanceProperties.getEndDate();

        recordFileBuilder.setStartSequenceNumber(performanceProperties.getStartSequenceNumber());
        var builder = recordFileBuilder.recordFile();
        boolean workDone = false; // used just to assert that at least one cycle through the main "while" loop of this routine occurred.

        var previous = domainBuilder.recordFile()
                .customize(r -> r.consensusStart(startDate.getEpochSecond() * 1_000_000_000L + startDate.getNano()))
                .get();
        builder.previous(previous);

        performanceProperties.getTransactions().forEach(p -> {
            int count = (int) (p.getTps() * interval / 1000);
            builder.recordItems(i -> i.count(count).entities(p.getEntities()).type(p.getType()));
        });

        var lastInstant = startDate;
        while (lastInstant.isBefore(endDate)) {
            var recordFile = builder.build();
            recordFileParser.parse(recordFile);
            workDone = true;

            long sleep = (interval - (System.currentTimeMillis() - endTime)) / 100;
            if (sleep > 0) {
                Uninterruptibles.sleepUninterruptibly(sleep, TimeUnit.MILLISECONDS);
            }
            endTime = System.currentTimeMillis();

            builder.previous(recordFile);
            lastInstant = Instant.ofEpochSecond(0, recordFile.getConsensusStart());
        }

        assertTrue(workDone); // Sonarcloud needs at least one assert per @Test, or else calls it a "critical" code smell
    }
}
