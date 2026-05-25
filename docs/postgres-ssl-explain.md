# Detailed PostgreSQL Configuration Explanation

Berikut penjelasan detail untuk konfigurasi PostgreSQL pada setup hardened rootless Podman Anda.

---

# PostgreSQL Configuration File

File:

```text id="cwcyo0"
~/.config/containers/postgres/postgresql.conf
```

Digunakan untuk:

* konfigurasi server PostgreSQL
* TLS
* memory tuning
* WAL tuning
* logging
* network behavior

---

# Full Configuration

```conf id="axksfi"
listen_addresses = '*'

ssl = on

ssl_cert_file = '/certs/server.crt'
ssl_key_file = '/certs/server.key'

ssl_min_protocol_version = 'TLSv1.3'

password_encryption = scram-sha-256

shared_buffers = 256MB
work_mem = 16MB
maintenance_work_mem = 64MB
effective_cache_size = 768MB

wal_compression = on

checkpoint_completion_target = 0.9

max_wal_size = 2GB
min_wal_size = 512MB

logging_collector = on
log_connections = on
log_disconnections = on

log_line_prefix = '%m [%p] %u@%d '

log_statement = 'ddl'
```

---

# NETWORK CONFIGURATION

---

# `listen_addresses`

```conf id="ah9nlr"
listen_addresses = '*'
```

## Fungsi

Menentukan interface network yang didengarkan PostgreSQL.

---

## Kenapa Menggunakan `*`

Karena PostgreSQL harus:

* menerima koneksi dari container lain
* dalam network backend Podman

Contoh:

* Forgejo
* Authelia

akan connect menggunakan:

```text id="6ddzjlwm"
postgres:5432
```

---

## Kenapa Tidak `127.0.0.1`

Kalau:

```conf id="g8dbd8"
listen_addresses = '127.0.0.1'
```

maka:

* hanya localhost container postgres sendiri
* container lain gagal connect

---

## Kenapa Tetap Aman Walaupun `*`

Karena Anda memakai:

```bash id="ry91ck"
-p 127.0.0.1:5432:5432
```

Artinya:

* host hanya expose ke localhost
* LAN tidak bisa akses
* internet tidak bisa akses

Jadi security boundary ada di:

* Podman port binding
* backend network isolation

---

# TLS CONFIGURATION

---

# `ssl`

```conf id="jlwmx5"
ssl = on
```

## Fungsi

Mengaktifkan TLS/SSL di PostgreSQL.

---

## Yang Dienkripsi

Saat aktif:

* password authentication
* SQL query
* SQL result
* session traffic

semuanya terenkripsi.

---

## Tanpa `ssl = on`

Traffic PostgreSQL:

* plaintext
* bisa di-sniff di network

---

# `ssl_cert_file`

```conf id="9hmsfh"
ssl_cert_file = '/certs/server.crt'
```

## Fungsi

Certificate public TLS server.

Digunakan agar client:

* mengenali identitas server
* bisa melakukan TLS handshake

---

## Kenapa Di `/certs`

Karena mount:

```bash id="jlwmu8"
-v ~/.config/containers/postgres/certs:/certs:ro
```

lebih clean dibanding menyimpan cert di data directory PostgreSQL.

---

# `ssl_key_file`

```conf id="hjlwmz"
ssl_key_file = '/certs/server.key'
```

## Fungsi

Private key TLS server.

Digunakan untuk:

* decryption
* TLS handshake
* certificate identity

---

## Security Penting

File ini wajib:

* ownership `999:999`
* permission `600`

Kalau tidak:
PostgreSQL menolak boot.

---

# `ssl_min_protocol_version`

```conf id="jlwm9u"
ssl_min_protocol_version = 'TLSv1.3'
```

## Fungsi

Memaksa minimum protocol TLS.

---

## Kenapa TLSv1.3

Karena:

* lebih cepat
* lebih aman
* cipher modern
* forward secrecy lebih baik

---

## Yang Ditolak

TLS lama:

* TLSv1.0
* TLSv1.1
* TLSv1.2

akan ditolak.

---

# AUTHENTICATION

---

# `password_encryption`

```conf id="jlwm6i"
password_encryption = scram-sha-256
```

## Fungsi

Menentukan format hash password PostgreSQL.

---

## Kenapa SCRAM

SCRAM-SHA-256:

* modern
* salted
* jauh lebih aman dibanding md5

---

## Jangan Gunakan

```conf id="jlwmtr"
md5
```

karena:

* lebih lemah
* deprecated secara praktis

---

# MEMORY TUNING

---

# `shared_buffers`

```conf id="jlwm0t"
shared_buffers = 256MB
```

## Fungsi

RAM internal PostgreSQL cache.

---

## Pengaruh

Semakin besar:

* query lebih cepat
* disk IO lebih sedikit

tetapi:

* RAM usage meningkat

---

## Rekomendasi

| RAM Host | shared_buffers |
| -------- | -------------- |
| 2GB      | 256MB          |
| 4GB      | 1GB            |
| 8GB      | 2GB            |

---

# `work_mem`

```conf id="jlwmh7"
work_mem = 16MB
```

## Fungsi

RAM untuk:

* sorting
* hash
* aggregation

per query operation.

---

## Bahaya Jika Terlalu Besar

Karena:

* berlaku per operation
* per connection

100 query × 16MB:

* bisa sangat besar total RAM usage

---

# `maintenance_work_mem`

```conf id="jlwmr6"
maintenance_work_mem = 64MB
```

## Fungsi

RAM untuk:

* VACUUM
* CREATE INDEX
* maintenance task

---

## Kenapa Bisa Lebih Besar

Karena:

* maintenance tidak sesering query normal
* membantu indexing lebih cepat

---

# `effective_cache_size`

```conf id="jlwmxy"
effective_cache_size = 768MB
```

## Fungsi

Estimasi cache total OS + PostgreSQL.

---

## Ini Bukan Alokasi RAM

Hanya hint untuk query planner.

---

## Pengaruh

Planner jadi:

* lebih optimis memakai index
* query plan lebih baik

---

# WAL CONFIGURATION

---

# `wal_compression`

```conf id="jlwmqp"
wal_compression = on
```

## Fungsi

Mengcompress WAL write.

---

## Keuntungan

* write SSD lebih kecil
* WAL lebih hemat
* replication lebih ringan

---

## Cocok Untuk

* SSD
* NVMe
* homelab modern

---

# `checkpoint_completion_target`

```conf id="jlwmby"
checkpoint_completion_target = 0.9
```

## Fungsi

Menyebarkan checkpoint write lebih merata.

---

## Kenapa Penting

Mengurangi:

* IO spike
* lag
* stutter

---

# `max_wal_size`

```conf id="jlwmnh"
max_wal_size = 2GB
```

## Fungsi

Batas maksimum WAL sebelum checkpoint.

---

## Semakin Besar

* checkpoint lebih jarang
* write performance lebih baik

tetapi:

* recovery lebih lama

---

# `min_wal_size`

```conf id="jlwm8y"
min_wal_size = 512MB
```

## Fungsi

Minimum WAL dipertahankan.

---

## Tujuan

Mengurangi:

* WAL create/delete terlalu sering
* filesystem fragmentation

---

# LOGGING CONFIGURATION

---

# `logging_collector`

```conf id="jlwm7q"
logging_collector = on
```

## Fungsi

Mengaktifkan PostgreSQL log collector.

---

## Tanpa Ini

Log hanya stdout container.

---

## Dengan Ini

PostgreSQL membuat:

* structured log
* rotating log
* persistent internal log

---

# `log_connections`

```conf id="jlwmcn"
log_connections = on
```

## Fungsi

Mencatat koneksi masuk.

---

## Berguna Untuk

* audit
* intrusion detection
* debugging

---

# `log_disconnections`

```conf id="jlwm0x"
log_disconnections = on
```

## Fungsi

Mencatat koneksi keluar.

---

# `log_line_prefix`

```conf id="jlwmja"
log_line_prefix = '%m [%p] %u@%d '
```

## Fungsi

Format prefix setiap log line.

---

## Penjelasan

| Token | Arti       |
| ----- | ---------- |
| `%m`  | timestamp  |
| `%p`  | process ID |
| `%u`  | username   |
| `%d`  | database   |

---

## Contoh

```text id="jlwmyn"
2026-05-25 10:00:00 [55] postgres@forgejo
```

---

# `log_statement`

```conf id="jlwmiz"
log_statement = 'ddl'
```

## Fungsi

Log query tertentu.

---

## `ddl`

Mencatat:

* CREATE
* ALTER
* DROP

---

## Kenapa Tidak `all`

Karena:

* terlalu verbose
* performa turun
* log membengkak

---

# SECURITY MODEL FINAL

Setup Anda sekarang:

✔ TLSv1.3
✔ localhost-only host exposure
✔ internal backend network
✔ rootless Podman
✔ SCRAM-SHA-256
✔ no-new-privileges
✔ cap-drop ALL
✔ internal CA
✔ TLS-only PostgreSQL
✔ container isolation
✔ no external database exposure

Ini sudah sangat mendekati production-grade homelab architecture.
