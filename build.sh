#!/bin/bash -x
cd lede
echo "update feeds"
./scripts/feeds update -a || { echo "update feeds failed"; exit 1; }
echo "install feeds"
./scripts/feeds install -a || { echo "install feeds failed"; exit 1; }
#./scripts/feeds update qmodem
./scripts/feeds install -a -f -p qmodem || { echo "install qmodem feeds failed"; exit 1; }
cat ../m28c.config > .config
echo "make defconfig"
make defconfig || { echo "defconfig failed"; exit 1; }
echo "diff initial config and new config:"
diff ../m28c.config .config
echo "make download"
# 减少下载并行任务数
make download -j2 || { echo "download failed"; exit 1; }
echo "make lede"
# 进一步减少并行任务数以避免资源限制，使用2个线程
# 同时禁用详细输出以减少日志量和I/O压力
echo "使用2个并行任务编译，避免GitHub Actions资源限制"
echo "注意：禁用详细输出以减少日志量"
make -j2 || { echo "make failed"; exit 1; }
