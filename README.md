# Getting Started with Verilog
通过北京交通大学的网课学习`Verilog HDL`入门。  
+ 视频地址：https://www.bilibili.com/video/BV1hX4y137Ph
+ 在`Ubuntu WSL`上使用`VS Code`、`Icarus Verilog`和`GTKWave`的开源解决方案进行`Testbench`仿真。


可以使用`apt-get`包管理器安装`Icarus Verilog`和`GTKWave`：
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
![GTKWave样例](https://ghproxy.futils.com/https://github.com/LYB926/Getting_Started_with_Verilog/blob/main/Lesson7/tri_gen_wave.png "GTKWave样例")