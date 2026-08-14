export interface foundMeData {
    eName?: string;
    eUsername?: string;
    eId?: string;
    ePhone?: string;
}
export const FOUND_FORM_RULES = {
    eName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
    eUsername: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
    eId: [{ required: true, message: '请输入身份证号', trigger: 'blur' }],
    ePhone: [{ required: true, message: '请输入手机号', trigger: 'blur' }]
}