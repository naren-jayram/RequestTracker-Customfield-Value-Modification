## Request Tracker - Modifying Custom Field Values
To change the concerned custom field's custom field value in *Request Tracker for Incident Response (RTIR)* to the desired one.

#### Prerequisites
1. Access to Request Tracker for Incident Response (RTIR).
2. Custom field name should exist in any of the RT Queues. You can create one through RT GUI console.
3. You should have the list of custom field values associated with a custom field.
4. Create a **input.csv** file and feed the exact existing custom field values (for a concerned custom field name). 
*P.S:* Please make sure one custom field value goes in each line.

#### Usage
```
perl rt_customfield_value_modification.pl
```
#### Additional Info
* We need to have an exact custom field value to play with RT. RT does not support wild character search in custom field values.
* If you wish to use it as a **RT scip**, please refer *rt_scrip.txt*
