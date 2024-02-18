select ps.name , pf.name , boundary_id , value 
from sys.partition_schemes ps 
inner join sys.partition_functions pf on pf.function_id = ps.function_id
inner join sys.partition_range_values prf on pf.function_id = prf.function_id
