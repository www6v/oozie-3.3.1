--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

--create temporary function myexp as 'com.gw.hive.udf.udtf.ExplodeEx';
--CREATE external TABLE IF NOT EXISTS log_tbl_104_raw (    key1 array<string>)PARTITIONED BY(log_time string) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' WITH SERDEPROPERTIES("ignore.malformed.json" = "true");

--ALTER TABLE log_tbl_104_raw DROP IF EXISTS PARTITION (log_time='${LOGDATE}');
--alter table log_tbl_104_raw add partition(log_time='${LOGDATE}') location '${INPUTDATA}';
--CREATE external TABLE IF NOT EXISTS log_tbl_104 (deviceID string,user string, lt string, phonenum string, platform string, phonetype string, clientver string, macadd string,ip string, nettype string,region string,isp string)PARTITIONED BY(log_time string);

--INSERT OVERWRITE  DIRECTORY '${OUTPUTDATA}' select key1[1],key1[2],key1[3],key1[4],key1[5],key1[6],key1[7],key1[8],key1[9],key1[10],key1[11],key1[12] from log_tbl_104_raw where log_time=${LOGDATE};

--ALTER TABLE log_tbl_104 DROP IF EXISTS PARTITION (log_time='${LOGDATE}');
--alter table log_tbl_104 add partition(log_time='${LOGDATE}') location '${OUTPUTDATA}';


--insert overwrite directory '${OUTPUTDATA}'  select t.rid,t.date,count(distinct(t.did)) from (select log_tbl_103_raw.key1[1] as did,substring(log_tbl_103_raw.key1[3],0,10) as date,log_tbl_104_raw.key1[11] as rid from log_tbl_103_raw join log_tbl_104_raw on log_tbl_103_raw.key1[1]=log_tbl_104_raw.key1[1])t where date=${LOGDATE}  group by t.rid,t.date;


insert overwrite directory '/user/hadoop/onlinepeople' select t.rid,t.date,count(distinct(t.did)) from (select log_tbl_103_raw.key1[1] as did,substring(log_tbl_103_raw.key1[3],0,10) as date,log_tbl_104_raw.key1[11] as rid from log_tbl_103_raw join log_tbl_104_raw on log_tbl_103_raw.key1[1]=log_tbl_104_raw.key1[1] where log_tbl_103_raw.log_time="20130627" and log_tbl_104_raw.log_time="20130627")t group by t.rid,t.date;
