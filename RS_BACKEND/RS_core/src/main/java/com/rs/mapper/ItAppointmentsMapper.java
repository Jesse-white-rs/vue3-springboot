package com.rs.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.rs.domain.ItAppointments;
import org.apache.ibatis.annotations.Mapper;


/**
* @author Administrator
* @description 针对表【it_appointments】的数据库操作Mapper
* @createDate 2026-06-17 09:39:45
* @Entity com.rs.domain.ItAppointments
*/
@Mapper
public interface ItAppointmentsMapper extends BaseMapper<ItAppointments> {


}
