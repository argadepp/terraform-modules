# Cross-Account AWS Access Using IAM Roles and Terraform

![alt Cross Account](https://github.com/argadepp/terraform-modules/tree/master/modules/cross-account/images/cross-account-2.png?raw=true)


## 📌 Introduction
### Overview of Cross-Account AWS Access
Cross-account access in AWS allows one AWS account (Account B) to securely access resources in another AWS account (Account A) using IAM roles and temporary credentials.

### Why Cross-Account Access is Needed?
- **Sharing S3 Buckets** securely between accounts.
- **Accessing Security Groups, VPCs, and EC2 instances** from another account.
- **Centralized Management** for AWS resources across multiple accounts.

### How AWS IAM Roles, STS AssumeRole, and Terraform Help?
- **IAM Roles** enable secure access without sharing static credentials.
- **AWS Security Token Service (STS) AssumeRole** provides temporary credentials.
- **Terraform** automates the creation of roles, policies, and EC2 instances across accounts.

---

## 🔧 AWS Cross-Account Setup
### **Account A (Resource Owner)**
1. Create an **IAM Role (CrossAccountAccess)** with a trust policy allowing Account B to assume it.
2. Attach necessary policies (S3, EC2, and VPC access).

### **Account B (Requester)**
1. Create an **IAM Role for EC2** that assumes **CrossAccountAccess** in Account A.
2. Attach permissions to allow `sts:AssumeRole`.

---

## 💻 Terraform Code Implementation
### **Terraform Setup**
Define AWS provider and configure two accounts.

### **Steps in Terraform:**
✅ Create IAM Role in **Account A** (`CrossAccountAccess`).
✅ Create IAM Role in **Account B** with `sts:AssumeRole` permission.
✅ Deploy an **EC2 instance in Account B** with user data to install AWS CLI.

---

## 🔍 Testing Cross-Account Access
### **Verify IAM Role in Account A**
- Check policies and trust relationships.

### **Access Account A’s Resources from EC2 in Account B**
✅ **Test S3 Access:**
```sh
aws s3 ls s3://account-a-bucket --profile assumed-role
```
✅ **Check VPCs in Account A:**
```sh
aws ec2 describe-vpcs --profile assumed-role
```
✅ **Check EC2 Instances in Account A:**
```sh
aws ec2 describe-instances --profile assumed-role
```

---

## ⚙️ Automating Role Assumption with AWS CLI
- Use `aws sts assume-role` to get temporary credentials.
- Automate role switching using named profiles in `~/.aws/config`.

---

## 🎯 Conclusion & Next Steps
✅ Successfully set up **Cross-Account IAM Role** using Terraform.
✅ **Best Practices for Securing Cross-Account Access:**
- Grant **least privilege** access.
- **Monitor usage** via CloudTrail.
- Automate role switching for better security.

📺 **Watch the Video Tutorial Here:**  
[![Cross-Account AWS Access Video](https://youtu.be/LJnd7mbygvw)

🔔 **Subscribe for More AWS & DevOps Content!** 🚀

