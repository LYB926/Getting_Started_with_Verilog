# Getting Started with Verilog
通过北京交通大学的网课学习Verilog HDL入门。  
+ 视频地址：https://www.bilibili.com/video/BV1hX4y137Ph
+ 在Ubuntu WSL上使用VS Code、Icarus Verilog和GTKWave的开源解决方案进行Testbench仿真。


可以使用apt包管理器安装Icarus Verilog和GTKWave：
```
sudo apt-get install iverilog
sudo apt-get install gtkwave
```


通过以下指令编译综合以及查看仿真结果：
```
iverilog -o file_tb file.v
vvp file_tb
gtkwave file_tb.vcd
```


使用GTKWave打开vcd波形文件后的界面如下：
