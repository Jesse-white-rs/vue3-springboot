package com.rs.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 
 * @TableName it_appointments
 */
@Data
@TableName("it_appointments")
public class ItAppointments implements Serializable {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private String name;

    /**
     * 
     */
    private String problem;

    /**
     * 
     */
    private Integer status;

    /**
     * 
     */
    private Date createat;

    /**
     * 
     */
    private String createby;

    /**
     * 
     */
    private String evaluation;

    /**
     * 
     */
    private Integer level;

    private static final long serialVersionUID = 1L;

    /**
     * 
     */
    public String getName() {
        return name;
    }

    /**
     * 
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * 
     */
    public String getProblem() {
        return problem;
    }

    /**
     * 
     */
    public void setProblem(String problem) {
        this.problem = problem;
    }

    /**
     * 
     */
    public Integer getStatus() {
        return status;
    }

    /**
     * 
     */
    public void setStatus(Integer status) {
        this.status = status;
    }

    /**
     * 
     */
    public Date getCreateat() {
        return createat;
    }

    /**
     * 
     */
    public void setCreateat(Date createat) {
        this.createat = createat;
    }

    /**
     * 
     */
    public String getCreateby() {
        return createby;
    }

    /**
     * 
     */
    public void setCreateby(String createby) {
        this.createby = createby;
    }

    @Override
    public boolean equals(Object that) {
        if (this == that) {
            return true;
        }
        if (that == null) {
            return false;
        }
        if (getClass() != that.getClass()) {
            return false;
        }
        ItAppointments other = (ItAppointments) that;
        return (this.getId() == null ? other.getId() == null : this.getId().equals(other.getId()))
            && (this.getName() == null ? other.getName() == null : this.getName().equals(other.getName()))
            && (this.getProblem() == null ? other.getProblem() == null : this.getProblem().equals(other.getProblem()))
            && (this.getStatus() == null ? other.getStatus() == null : this.getStatus().equals(other.getStatus()))
            && (this.getCreateat() == null ? other.getCreateat() == null : this.getCreateat().equals(other.getCreateat()))
            && (this.getCreateby() == null ? other.getCreateby() == null : this.getCreateby().equals(other.getCreateby()))
            && (this.getEvaluation() == null ? other.getEvaluation() == null : this.getEvaluation().equals(other.getEvaluation()))
            && (this.getLevel() == null ? other.getLevel() == null : this.getLevel().equals(other.getLevel()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
        result = prime * result + ((getName() == null) ? 0 : getName().hashCode());
        result = prime * result + ((getProblem() == null) ? 0 : getProblem().hashCode());
        result = prime * result + ((getStatus() == null) ? 0 : getStatus().hashCode());
        result = prime * result + ((getCreateat() == null) ? 0 : getCreateat().hashCode());
        result = prime * result + ((getCreateby() == null) ? 0 : getCreateby().hashCode());
        result = prime * result + ((getEvaluation() == null) ? 0 : getEvaluation().hashCode());
        result = prime * result + ((getLevel() == null) ? 0 : getLevel().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", name=").append(name);
        sb.append(", problem=").append(problem);
        sb.append(", status=").append(status);
        sb.append(", createat=").append(createat);
        sb.append(", createby=").append(createby);
        sb.append(", evaluation=").append(evaluation);
        sb.append(", level=").append(level);
        sb.append("]");
        return sb.toString();
    }
}