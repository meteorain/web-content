---
title: Untitled
---

https://stackoverflow.com/a/65927902/10936088

密码中包含@

[](https://stackoverflow.com/posts/65927902/timeline)

From pgloader **Reference Manual** ([https://pgloader.readthedocs.io/en/latest/pgloader.html](https://pgloader.readthedocs.io/en/latest/pgloader.html)):

command line:

```sql
pgloader SOURCE TARGET
```

**Source Connection String**

```sql
db://user:pass@host:port/dbname
```

Where db might be of sqlite, mysql or mssql.

**Connection String**

The parameter is expected to be given as a Connection URI as documented in the PostgreSQL documentation at [http://www.postgresql.org/docs/9.3/static/libpq-connect.html#LIBPQ-CONNSTRING](http://www.postgresql.org/docs/9.3/static/libpq-connect.html#LIBPQ-CONNSTRING).

```sql
postgresql://[user[:password]@][netloc][:port][/dbname][?option=value&...]
```

user

Can contain any character, including colon (:) which must then be doubled (::) and at-sign (@) which must then be doubled (@@).

When omitted, the user name defaults to the value of the PGUSER environment variable, and if it is unset, the value of the USER environment variable.

password

Can contain any character, including the at sign (@) which must then be doubled (@@). To leave the password empty, when the user name ends with at at sign, you then have to use the syntax user:@.

When omitted, the password defaults to the value of the PGPASSWORD environment variable if it is set, otherwise the password is left unset.

When no password is found either in the connection URI nor in the environment, then pgloader looks for a .pgpass file as documented at [https://www.postgresql.org/docs/current/static/libpq-pgpass.html](https://www.postgresql.org/docs/current/static/libpq-pgpass.html)



## smallint 转换

```
LOAD DATABASE
    FROM mysql://root:rom*CRDC@@2022@172.20.10.3:3306/jeecg-boot
    INTO postgresql://postgres:rom*CRDC@@2022@172.20.10.3:54320/jeecg-boot

WITH include no drop, create tables, create indexes, reset sequences

CAST type tinyint when (= 1 precision) to smallint drop typemod

SET work_mem to '16MB', maintenance_work_mem to '512 MB', client_encoding to 'UTF-8';
```
