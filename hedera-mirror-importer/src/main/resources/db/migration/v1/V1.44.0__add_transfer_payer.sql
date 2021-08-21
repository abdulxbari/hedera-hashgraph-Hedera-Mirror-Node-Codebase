-------------------
-- Add transaction payer to transfer tables
-------------------
-- add payer to transfer tables
alter table crypto_transfer
    add column if not exists transaction_payer_account_id bigint;

alter table nft_transfer
    add column if not exists transaction_payer_account_id bigint;

alter table non_fee_transfer
    add column if not exists transaction_payer_account_id bigint;

alter table token_transfer
    add column if not exists transaction_payer_account_id bigint;

SELECT NOW();
select 'create transfers_subset';
-- retrieve subset of transaction representing transfers
create temporary table if not exists transfers_subset as
select  consensus_ns, result, payer_account_id
from transaction
where type = 14
order by consensus_ns;

SELECT NOW();
select 'transfers_subset index';
create unique index if not exists transfers_subset__time_res
    on transfers_subset (consensus_ns, result);
--limit 1000000;
SELECT NOW();
select 'crypto transfers_subset';

-- from transaction table, insert payer to transfer tables
update crypto_transfer
set transaction_payer_account_id = payer_account_id
from transfers_subset
where consensus_timestamp = transfers_subset.consensus_ns and result = 22;
SELECT NOW();

--select 'crypto_map';
--with crypto_map as (
--    select distinct t.consensus_ns, t.result, t.payer_account_id
--    from crypto_transfer ct
--    join transaction_temp t on ct.consensus_timestamp = t.consensus_ns and t.type = 14
--    order by t.consensus_ns
--)
--update crypto_transfer
--set transaction_payer_account_id = payer_account_id
--from crypto_map
--where consensus_timestamp = crypto_map.consensus_ns;
--SELECT NOW();

select 'nft transfers_subset';
update nft_transfer
set transaction_payer_account_id = payer_account_id
from transfers_subset
where consensus_timestamp = transfers_subset.consensus_ns and result = 22;
SELECT NOW();
--select 'nft map';
--with nft_map as (
--    select distinct t.consensus_ns, t.result, t.payer_account_id
--    from nft_transfer nft
--    join transaction_temp t on nft.consensus_timestamp = t.consensus_ns and t.type = 14 and result = 22
--    order by t.consensus_ns
--)
--update nft_transfer
--set transaction_payer_account_id = payer_account_id
--from nft_map
--where consensus_timestamp = nft_map.consensus_ns;
--SELECT NOW();

select 'non fee transfers_subset';
update non_fee_transfer
set transaction_payer_account_id = payer_account_id
from transfers_subset
where consensus_timestamp = transfers_subset.consensus_ns;
SELECT NOW();
--select 'non_fee_map';
--with non_fee_map as (
--    select distinct t.consensus_ns, t.result, t.payer_account_id
--    from non_fee_transfer nftr
--    join transaction_temp t on nftr.consensus_timestamp = t.consensus_ns and t.type = 14
--    order by t.consensus_ns
--)
--update non_fee_transfer
--set transaction_payer_account_id = payer_account_id
--from non_fee_map
--where consensus_timestamp = non_fee_map.consensus_ns;
--SELECT NOW();

select 'token transfers_subset';
update token_transfer
set transaction_payer_account_id = payer_account_id
from transfers_subset
where consensus_timestamp = transfers_subset.consensus_ns and result = 22;
SELECT NOW();
--select 'token_map';
--with token_map as (
--    select distinct t.consensus_ns, t.result, t.payer_account_id
--    from token_transfer ttr
--    join transaction_temp t on ttr.consensus_timestamp = t.consensus_ns and t.type = 14 and result = 22
--    order by t.consensus_ns
--)
--update token_transfer
--set transaction_payer_account_id = payer_account_id
--from token_map
--where consensus_timestamp = token_map.consensus_ns;
--SELECT NOW();

-- set no nulls
alter table crypto_transfer
    alter column transaction_payer_account_id set not null;
alter table nft_transfer
    alter column transaction_payer_account_id set not null;
alter table non_fee_transfer
    alter column transaction_payer_account_id set not null;
alter table token_transfer
    alter column transaction_payer_account_id set not null;

SELECT NOW();
