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

package com.hedera.mirror.importer.parser.record.transactionhandler;

import com.hedera.mirror.common.domain.entity.Entity;
import com.hedera.mirror.common.domain.entity.EntityId;
import com.hedera.mirror.common.domain.entity.EntityOperation;
import com.hedera.mirror.common.domain.transaction.RecordItem;
import com.hedera.mirror.common.domain.transaction.Transaction;
import com.hedera.mirror.common.domain.transaction.TransactionType;
import com.hedera.mirror.importer.domain.EntityIdService;
import com.hedera.mirror.importer.parser.record.entity.EntityListener;
import lombok.AccessLevel;
import lombok.CustomLog;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@CustomLog
@RequiredArgsConstructor(access = AccessLevel.PROTECTED)
abstract class AbstractEntityCrudTransactionHandler implements TransactionHandler {

    protected final EntityIdService entityIdService;

    protected final EntityListener entityListener;

    @Getter
    private final TransactionType type;

    @Override
    public final void updateTransaction(Transaction transaction, RecordItem recordItem) {
        doUpdateTransaction(transaction, recordItem);
        EntityId entityId = transaction.getEntityId();
        EntityOperation entityOperation = type.getEntityOperation();

        if (entityOperation != EntityOperation.NONE && !EntityId.isEmpty(entityId) && recordItem.isSuccessful()) {
            updateEntity(entityId, recordItem);
        }
    }

    protected void doUpdateTransaction(Transaction transaction, RecordItem recordItem) {}

    protected final void updateEntity(EntityId entityId, RecordItem recordItem) {
        long consensusTimestamp = recordItem.getConsensusTimestamp();
        Entity entity = entityId.toEntity();
        EntityOperation entityOperation = type.getEntityOperation();

        if (entityOperation == EntityOperation.CREATE) {
            entity.setCreatedTimestamp(consensusTimestamp);
            entity.setDeleted(false);
        } else if (entityOperation == EntityOperation.UPDATE) {
            entity.setDeleted(false);
        } else if (entityOperation == EntityOperation.DELETE) {
            entity.setDeleted(true);
        }

        entity.setTimestampLower(consensusTimestamp);
        doUpdateEntity(entity, recordItem);
    }

    protected abstract void doUpdateEntity(Entity entity, RecordItem recordItem);
}
