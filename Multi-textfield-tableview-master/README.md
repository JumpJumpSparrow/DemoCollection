### tableview 中包含多个输入框时，该如何优雅地处理？

1.剥离 UI 层，UI层输出固定数据  
2.通过 KVC 使 tableview 的 textField 和 model 的字段形成一一映射，identifier 对应 model 内的字段。  
3.有序数据集和记录tableview cell 的顺序，由于不再需要区分到底哪个输入框的输入对应哪个字段，极大的简化了代码  

<p align="center" >
<img width="300" height="220"  src="https://github.com/JumpJumpSparrow/DemoCollection/blob/master/Multi-textfield-tableview-master/screenShot.png"/>
</p>  
 
