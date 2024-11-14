# Requirements 

Tested with Java 8.

# Compile

```
./gradlew shadowJar
```

Or

```
gradlew.bat shadowJar
```

# Usage

The logs directory needs to have the hex log files alphabetically ordered. These log files need to contain the complete sequential log entries, starting with the log entry `0x0001`. **Considering that the whole hex log files could be fabricated up to the last log entry and verify successfully, for performing a secure verification, at least a new fresh log entry has to be retrieved from the HSM just before performing the verification.**

Here you have sample consecutive hex log files generated with `yubihsm-shell -a get-logs --outformat hex --out $(date +"%Y%m%d_%H%M%S").log`:

`20241103_164057.log`:

```
000000000001ffffffffffffffffffffffffffff4e1352bc799ee93c8df96b3cb7193fe10002000000ffff000000000000000000eda5e0701c835c2835ca0622d708a006000303000affff0001ffff83000029e4d3b388ea05b8197ed1d2e56f824d07050004040011ffff0001ffff84000029e400adaa113888c2a0aea9391230213385
```

`20241103_164112.log`:

```
0000000000054000000001ffffffffc0000029e5f4635eeb009f2a4a24f6a33292b4cb0f000603000affff0001ffff83000029e7f45fda4fad8bbe44aff8526e489b03020007040011ffff0001ffff84000029e76b534eb0608bb7e42ae2184cdba8d61300086700020001ffffffffe7000029e8180fd56072dde51e12a2ba1c05d4ade300094000000001ffffffffc0000029e8d4613c7be3022d7d936384d105003727000a03000affff0001ffff8300002c3d4fd2c895a28ca4066c7641c966b9c5c2000b040011ffff0001ffff8400002c3d5267b27303f3885899ce950eaa7414bc
```

`20241103_164115.log`:

```
00000000000c4000000001ffffffffc000002c3e88908f7aa080a3cdbb699b3359a956fe000d03000affff0001ffff8300002c405a6a02b6600b44154007f23649b2c93d000e040011ffff0001ffff8400002c40c6a0e4bbc945c599f0b0b0c79d55252a000f6700020001ffffffffe700002c41ba9446259e662c75576361178c91aff500104000000001ffffffffc000002c4122f8a98966ffb9ad344d0f715af29a38001103000affff0001ffff8300002cb7b1f39419db584ad7aab5b96fb28b06ea0012040011ffff0001ffff8400002cb743379c9cf352a0697611d28f2c7ad5e9
```

Put them under `/path/to/hex_logs_directory` and execute the following:

```
$ java -jar build/libs/yubihsm-java-verify-audit-logs-1.0-SNAPSHOT-all.jar /path/to/hex_logs_directory 
Log files will be processed in the following order:
 - 20241103_164057.log
 - 20241103_164112.log
 - 20241103_164115.log
Log entries verification successful.
Verified log entries:
item:    1 -- cmd:                    0x00ff -- ... hash:  4e1352bc799ee93c 8df96b3cb7193fe1
...
item:   18 -- cmd:      Authenticate Session -- ... hash:  43379c9cf352a069 7611d28f2c7ad5e9
```

# Usage with Docker

Build image:

```
docker build -t yubihsm-java-verify-audit-logs .
```

Run container:

```
docker run -v /path/to/hex_logs_directory:/logs yubihsm-java-verify-audit-logs /logs
```

# TODOs

- Java for this program seems definitely overkill and I haven't verified the trustworthiness of the publicly available package `com.yubico:libyubihsm`. Evaluate to rewrite this in Python using https://github.com/Yubico/python-yubihsm or in plain Bash without any external dependency.
