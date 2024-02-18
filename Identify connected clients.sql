select dec.client_net_address , 
des.program_name , 
des.host_name , 
COUNT(dec.session_id) as connection_count 
from sys.dm_exec_sessions as des
inner join sys.dm_exec_connections as dec 
on des.session_id = dec.session_id 
group by dec.client_net_address , 
des.program_name , 
des.host_name 
order by des.program_name , dec.client_net_address
