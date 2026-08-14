// 定义用户数据类型
export interface Emp {
  id?: number;
  eAvatarpath?: string;
  eName?: string;
  eUsername?: string;
  ePassword?: string;
  eId?: string;
  ePhone?: string;
  eAge?: number;
  eDeptid?: string;
  eGender?: string;
  eCreatetime?: string;
  eUpdatetime?: string;
  eIsenabled?: number;
  eTelephone?: string;
  eBirthday?: string;
  eDescription?: string;
  eQywxid?: string;
}
// 定义用户角色类型
export interface Role {
  rId?: number;
  rName?: string;
  rInfo?: string;
}
// 定义用户部门类型
export interface Dept {
  id?: number;
  dName?: string;
}
// 定义企微用户类型 
export interface qywxUser {
  userid?: string;
  name?: string;
  departmentId?: string;
}
// 定义企微部门类型
export interface qywxDepartment {
  id?: number;
  name?: string;
  parentId?: number;
  orderNum?: number;
}
// 定义用户数据类型
export interface UserData {
  emp: Emp;
  role: Role;
  dept: Dept;
  isOnline: string;
  qywxUser: qywxUser;
  qywxDepartment: qywxDepartment;
}