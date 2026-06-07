Git 常用命令速查

一、基础配置
  
# 配置用户名、邮箱（全局，仅首次设置）
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

# 查看配置
git config --list

 
二、仓库初始化 & 关联远程
 
# 本地新建 Git 仓库
git init

# 克隆远程仓库到本地
git clone 仓库地址

# 关联远程仓库
git remote add origin 远程地址

# 查看远程仓库
git remote -v

# 删除远程关联
git remote remove origin

# 修改远程仓库地址
git remote set-url origin 新地址

 
三、文件状态 & 暂存
 
  
# 查看文件状态
git status

# 添加单个文件到暂存区
git add 文件名

# 添加所有改动文件到暂存区
git add .

# 撤销暂存（不删除文件）
git reset HEAD 文件名
git reset HEAD .

 
四、提交版本
 
  
# 提交到本地仓库
git commit -m "提交说明"

# 修改上一次提交备注（不新增版本）
git commit --amend

 
五、拉取 & 推送远程
 
  
# 拉取远程代码（合并到本地）
git pull origin 分支名

# 首次拉取（本地远程无关联历史）
git pull origin main --allow-unrelated-histories

# 推送本地分支到远程
git push origin 分支名

# 首次推送并绑定分支
git push -u origin 分支名

# 强制推送（谨慎！会覆盖远程）
git push -f

 
六、分支操作
 
  
# 查看本地分支
git branch

# 查看本地+远程分支
git branch -a

# 新建分支
git branch 分支名

# 切换分支
git checkout 分支名
# Git 2.23+ 新写法
git switch 分支名

# 新建并立即切换到该分支
git checkout -b 分支名
git switch -c 分支名

# 删除本地分支
git branch -d 分支名

# 删除远程分支
git push origin --delete 分支名

# 合并分支（先切到目标分支）
git merge 待合并分支名

 
七、版本回退 & 撤销修改
 
  
# 查看提交日志
git log
# 简洁版日志
git log --oneline

# 工作区撤销修改（恢复成最近版本）
git checkout -- 文件名
git checkout -- .

# 回退到指定版本（硬回退，丢弃所有改动）
git reset --hard 版本号

# 回退到上一个版本
git reset --hard HEAD^

 
八、临时储藏（切换分支前保存改动）
 
  
# 储藏当前工作区改动
git stash

# 查看储藏列表
git stash list

# 恢复最近一次储藏（不删除储藏记录）
git stash apply

# 恢复并删除储藏记录
git stash pop

# 删除所有储藏
git stash clear

 
九、标签（版本打标）
 
  
# 创建标签
git tag v1.0.0

# 查看标签
git tag

# 推送标签到远程
git push origin v1.0.0

# 推送所有标签
git push origin --tags

 
十、差异对比
 
  
# 对比工作区与暂存区差异
git diff

# 对比暂存区与本地版本库
git diff --cached