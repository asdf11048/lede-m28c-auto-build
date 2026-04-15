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
# 优化并行任务数：使用3个线程，平衡速度和稳定性
# 启用轻度详细输出以便调试
echo "使用3个并行任务编译，优化速度和稳定性"
echo "启用轻度详细输出 (V=sc)"
make -j3 V=sc || { echo "make failed"; exit 1; }
