package com.rs.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.rs.domain.EnjoyFood;
import org.apache.ibatis.annotations.Mapper;


/**
* @author Administrator
* @description 针对表【enjoy_food】的数据库操作Mapper
* @createDate 2026-06-12 18:31:47
* @Entity com.rs.domain.EnjoyFood
*/
@Mapper
public interface EnjoyFoodMapper extends BaseMapper<EnjoyFood> {


}
