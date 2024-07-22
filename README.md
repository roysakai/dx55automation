
## Debbug userdata

```bash
tail -f /var/log/cloud-init-output.log
```

## Valida rds

```bash
SHOW DATABASES;
```

```bash
SELECT DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME 
FROM INFORMATION_SCHEMA.SCHEMATA 
WHERE SCHEMA_NAME = 'acs';
```
```bash
SHOW GRANTS FOR 'incognito'@'%';
```