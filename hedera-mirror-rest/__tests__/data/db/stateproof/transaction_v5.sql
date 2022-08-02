--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.18
-- Dumped by pg_dump version 12.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
-- The following line is auto generated by pg_dump and there is no option to disable it. Clearing search_path globally
-- will cause the sql queries in our implementation fail (relation not found). So comment it out.
-- SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: mirror_node
--

INSERT INTO public.transaction (consensus_timestamp, type, result, payer_account_id, valid_start_ns, valid_duration_seconds, node_account_id, entity_id, initial_balance, max_fee, charged_tx_fee, memo, transaction_hash, transaction_bytes, scheduled) VALUES
(1614921782071338000, 33, 22, 1744, 1614921769532637508, 120, 3, 2241, 0, 3000000000, 841446, '\x', '\xc3cef4e7f49694630a02e3dbfcc94e45cc983e5b2473592a4fe0eb3e89c5999dbb20aeeddcacd53dd92a79ec47fb459c', NULL, false),
(1614921782161292000, 33, 22, 1744, 1614921773011663869, 120, 4, 2242, 0, 3000000000, 841446, '\x', '\x477c8e2ab5e4b71d64f4133f6e698c48cec6d2d6fbad0ad0cf8d6173e72caba3f12a97c2fd22f72eb593b4d9a460bee2', NULL, false),
(1614921782161294000, 40, 22, 1744, 1614921773517191276, 120, 4, 2244, 0, 500000000, 67512675, '\x', '\x2845ad0e074eff6b8d247565eb858aa88363527c7d5051e6371c74757f7407fc9bb02dcb9276a93392067a8d9f9f1df3', NULL, false),
(1614921783067800000, 33, 22, 1744, 1614921773591634826, 120, 5, 2243, 0, 3000000000, 841446, '\x', '\x9e87db9afceed06a1606aab197f0977426d4ab187b3260aebf77e6c28042bc4e4102772c5456362ec375291c4dbe71c0', NULL, false),
(1614921783108126999, 42, 22, 1744, 1614921770052316061, 30, 3, 2249, 0, 100000000, 8252739, '\x', '\x7a37f4dfeb8108f46186f2c9fa726320a6cfed87164402f4933da5a54fa0f6230b4fb35bfcaac8ec76d136addefca890', NULL, false),
(1614921783115201999, 42, 22, 1744, 1614921773715345860, 30, 3, 2250, 0, 100000000, 8251462, '\x', '\xcd918868e7d83e0adf0c80a2d897e1b17c42088878fe9c558265ced63b608b9ce42b3c2377cbede484499388d20d5188', NULL, false),
(1614921783306481000, 33, 22, 1744, 1614921774919141411, 120, 5, 2244, 0, 3000000000, 841446, '\x', '\x1fe8254ed70cd2f84ad5aab455a98fcf68a67a949b1815aeeb48e15931299a6a2cf09b20fdc58104ff027e5df8ba80d2', NULL, false),
(1614921784299486999, 44, 22, 1744, 1614921774400989382, 120, 3, 2250, 0, 500000000, 1165895, '\x7468697320697320746f6b656e207472616e73666572207363686564756c65207472616e73616374696f6e', '\x4d57e56dbd89232559e824acbd7dc1d02da2a40df51bec2c6dd4258c0519f735840554b361d3954f7c54cf061401174c', NULL, false),
(1614921784299487000, 14, 22, 1744, 1614921773715345860, 120, 3, NULL, 0, 100000000, 12542, '\x', '\xacc53f000590bafa922d86122869bef1a26a71f19c2e9d675bb530b1b3a00a66dd7469d33d2f47f5274bd9f334cf5ba0', NULL, true),
(1614921784863107999, 42, 22, 1744, 1614921772342959302, 30, 3, 2251, 0, 100000000, 8252739, '\x', '\x5537c4a59aa617639d9fbabb204f9fe406fa019a9e30a75222c99721da6c17b1b7f6a9278c6c1858435dd2417433c0aa', NULL, false),
(1614921784998257999, 44, 22, 1744, 1614921775061190616, 120, 3, 2249, 0, 500000000, 1165895, '\x7468697320697320746f6b656e207472616e73666572207363686564756c65207472616e73616374696f6e', '\x4de36094177e671d7c5999523a74b13e8530ba17bdb523ea5a6f02693a374ef71340c25f8a12e8ff738a9fe8f4c8e2f0', NULL, false),
(1614921784998258000, 14, 22, 1744, 1614921770052316061, 120, 3, NULL, 0, 100000000, 12542, '\x', '\xa8cdb8b268acc00eb4dfffee04574407a69e76a8078427faaf6a4739fbd7559fefdeb9cbe373a9bdf5e2263eef03bfeb', NULL, true),
(1614921785067232999, 42, 22, 1744, 1614921776055499860, 30, 3, 2252, 0, 100000000, 8252739, '\x', '\x0b2d06b06e6a60c6dbc17833eb1e6e973582c022e0819619bb4474e3b04fb15d2cbbc9696afe83ff3dc960a888fbb1ae', NULL, false),
(1614921785873900999, 44, 22, 1744, 1614921774573127724, 120, 3, 2251, 0, 500000000, 1165895, '\x7468697320697320746f6b656e207472616e73666572207363686564756c65207472616e73616374696f6e', '\x9c191bdbf0aec8fda666e1c5c994fc0cbbd416e0092992449f96f959278d0e5ade6df167e15eac29d8f95dd8af515039', NULL, false),
(1614921785873901000, 14, 22, 1744, 1614921772342959302, 120, 3, NULL, 0, 100000000, 12542, '\x', '\x5a40dea6dfa2742d2555e92a02b4bd23be2730885bbfbb15d9570791c2575d3ad8a956e84df485845702cfddd0211f97', NULL, true);

--
-- PostgreSQL database dump complete
--
