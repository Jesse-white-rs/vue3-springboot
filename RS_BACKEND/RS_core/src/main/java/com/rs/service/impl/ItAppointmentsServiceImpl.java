package com.rs.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.rs.domain.ItAppointments;
import com.rs.service.ItAppointmentsService;
import com.rs.mapper.ItAppointmentsMapper;
import org.springframework.stereotype.Service;

/**
* @author Administrator
* @description 针对表【it_appointments】的数据库操作Service实现
* @createDate 2026-06-17 09:39:45
*/
@Service
public class ItAppointmentsServiceImpl extends ServiceImpl<ItAppointmentsMapper, ItAppointments>
implements ItAppointmentsService{

}
