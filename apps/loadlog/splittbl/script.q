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
set hive.exec.compress.output=true;
set mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec;

create temporary function myexp as 'com.gw.hive.udf.udtf.ExplodeEx';
CREATE external TABLE IF NOT EXISTS log_tbl_103_raw (    key1 array<string>,    key2 array<array<string>>)PARTITIONED BY(log_time string) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' WITH SERDEPROPERTIES("ignore.malformed.json" = "true");

ALTER TABLE log_tbl_103_raw DROP IF EXISTS PARTITION (log_time='${LOGDATE}');
alter table log_tbl_103_raw add partition(log_time='${LOGDATE}') location '${INPUTDATA}';
CREATE external TABLE IF NOT EXISTS log_tbl_103 (id string,user string,ts string,dt int,obj string,funid int,click int)PARTITIONED BY(log_time string);

INSERT OVERWRITE  DIRECTORY '${OUTPUTDATA}'select c.c1,c.c2,c.c3,c.c4,c.c5,c.c6,c.c7 from (select key1[1] as c1,key1[2] as c2,key1[3] as c3,null as c4,null as c5,null as c6,null as c7 from log_tbl_103_raw where log_time=${LOGDATE} and key2 is not null and size(key2)=0 UNION ALL select b.c1 as c1,b.c2 as c2,b.c3 as c3,b.c4[0] as c4,b.c4[1] as c5,b.c4[2] as c6,b.c4[3] as c7 from (select myexp(key1[1],key1[2],key1[3],key2) as (c1,c2,c3,c4) from log_tbl_103_raw where log_time=${LOGDATE}) b)c;

ALTER TABLE log_tbl_103 DROP IF EXISTS PARTITION (log_time='${LOGDATE}');
alter table log_tbl_103 add partition(log_time='${LOGDATE}') location '${OUTPUTDATA}';

insert overwrite directory '${OUTPUTDATA2}' select id,user,log_time,obj,funid,sum(click) from log_tbl_103 where log_time=${LOGDATE} group by id,obj,user,funid,log_time;

