package com.rs.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.rs.controller.base.BaseController;
import com.rs.domain.ItAppointments;
import com.rs.exception.pojo.vo.ResultResponse;
import com.rs.service.ItAppointmentsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Timestamp;
import java.time.LocalDateTime;

@Slf4j
@RestController
@RequestMapping("/itAppointments")
public class ItAppointmentsController extends BaseController<ItAppointments, ItAppointmentsService> {

    @Autowired
    public ItAppointmentsController(ItAppointmentsService itAppointmentsService) {
        super(itAppointmentsService, ItAppointments.class);
    }


}
