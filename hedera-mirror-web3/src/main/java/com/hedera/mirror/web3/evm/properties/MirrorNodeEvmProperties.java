package com.hedera.mirror.web3.evm.properties;

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

import org.hyperledger.besu.datatypes.Address;
import org.springframework.boot.context.properties.ConfigurationProperties;

import com.hedera.services.evm.contracts.execution.EvmProperties;

@ConfigurationProperties(prefix = "hedera.mirror.web3.evm")
public class MirrorNodeEvmProperties implements EvmProperties {
    private String evmVersion;
    private Address fundingAccount;
    private boolean isDynamicEvmVersionEnabled;
    private int maxGasRefundPercentage;

    @Override
    public String evmVersion() {
        return evmVersion;
    }

    @Override
    public Address fundingAccountAddress() {
        return fundingAccount;
    }

    @Override
    public boolean dynamicEvmVersion() {
        return isDynamicEvmVersionEnabled;
    }

    @Override
    public int maxGasRefundPercentage() {
        return maxGasRefundPercentage;
    }
}
