/*
 * Copyright (C) 2019-2023 Hedera Hashgraph, LLC
 *
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
 */

package com.hedera.mirror.importer.repository;

import com.hedera.mirror.common.domain.token.TokenTransfer;
import java.util.List;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface TokenTransferRepository extends CrudRepository<TokenTransfer, TokenTransfer.Id>, RetentionRepository {

    @Query(nativeQuery = true, value = "select * from token_transfer where consensus_timestamp = ?1")
    List<TokenTransfer> findByConsensusTimestamp(long consensusTimestamp);

    @Modifying
    @Override
    @Query(nativeQuery = true, value = "delete from token_transfer where consensus_timestamp <= ?1")
    int prune(long consensusTimestamp);
}
