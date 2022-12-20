# Mini Server

> 一键启动集群环境

## 简介

### 目的

提供一套简单易用的代码，方便快速部署一个运行 Kubernetes 的服务器环境。

### 特点

- [x] 使用 PVE 作为虚拟化环境
- [x] 使用 Terraform 实现基础设施的管理
- [x] 使用 K3s 作为 Kubernetes 集群环境的运行时
- [x] 支持自动部署一个开启了 TUN 的 Clash Premium Vm 作为网关
- [ ] 使用 Terraform + Helm 管理集群内的基础应用

### 设施完整度

- [ ] 能够通过 Terraform 配置 PVE Host 环境
- [x] 通过 Terraform 以及 Cloud Image 快速在 PVE 中创建集群运行所需的 Vm
- [x] 提供一个开箱即用的 Clash 网关，改善集群环境的网络
- [x] 通过 SSH 连接在建好的 Vm 中部署 K3s 集群
- [ ] 通过 Terraform + Helm 部署 Ingress + Cert Manager，可以自动化管理 TLS 证书
- [ ] ...

## 使用

### 环境准备

1. 安装 PVE
2. 系统镜像：[Rocky Linux Cloud Image](https://mirrors.sdu.edu.cn/rocky/9.1/images/x86_64/) 中选择一个 Generic 镜像 
3. 在 PVE Host 下载镜像并导入为模板
4. 创建 PVE ID 与 Secret

#### 导入模板

```shell
wget https://mirrors.sdu.edu.cn/rocky/9.1/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2
wget https://mirrors.sdu.edu.cn/rocky/9.1/images/x86_64/Rocky-9-GenericCloud-LVM-9.1-20221130.0.x86_64.qcow2
qm create 9000 --name "rocky-9.1-20221130-cloudinit-template" --memory 1024 --cores 1 --net0 virtio,bridge=vmbr0
qm importdisk 9000 Rocky-9-GenericCloud-LVM-9.1-20221130.0.x86_64.qcow2 local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000
```

#### 创建 ID 与 Secret

```shell
pveum role add TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit"
pveum user add terraform-prov@pve
pveum aclmod / -user terraform-prov@pve -role TerraformProv
pveum user token add terraform-prov@pve terraform-token --privsep=0
```

### 部署应用

按需调整模板名称、IP 配置、Clash 配置文件等变量值，后执行

```shell
export PM_API_URL=https://192.168.5.126:8006/api2/json
export PM_API_TOKEN_ID=terraform-prov@pve\!terraform-token
export PM_API_TOKEN_SECRET=<uuid>

terraform init
terraform apply --auto-approve
```

### 定制

#### 不使用 PVE

`modules/vm` 模块是抽象了一个 vm 模块，如果使用 PVE 以外的 Provider 则需要完全重写 vm 模块。

#### 不使用 K3s

`modules/cluster` 中的 `k3s.tf` 内定义了 k3s 的配置信息，如果想要替换为原生 Kubernetes 等，可以自行找一下有没有合适的开源 module。

#### 不使用新部署的网关

`main.tf` 中，gateway 模块的配置中 `enable` 设置为 `false` 即可。

#### 其它定制项

待补充...

