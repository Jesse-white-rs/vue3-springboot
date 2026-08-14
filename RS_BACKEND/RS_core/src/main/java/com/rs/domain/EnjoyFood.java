package com.rs.domain;

import java.math.BigDecimal;

/**
 * 
 * @TableName enjoy_food
 */
public class EnjoyFood {
    /**
     * 菜品id
     */
    private Integer id;

    /**
     * 菜品类型
     */
    private String type;

    /**
     * 菜名
     */
    private String name;

    /**
     * 位置
     */
    private String location;

    /**
     * 图片
     */
    private String pic;

    /**
     * 价格
     */
    private BigDecimal price;

    /**
     * 状态
     */
    private String status;

    /**
     * 描述
     */
    private String remark;

    /**
     * 补充内容
     */
    private String extra;

    /**
     * 菜品id
     */
    public Integer getId() {
        return id;
    }

    /**
     * 菜品id
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * 菜品类型
     */
    public String getType() {
        return type;
    }

    /**
     * 菜品类型
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * 菜名
     */
    public String getName() {
        return name;
    }

    /**
     * 菜名
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * 位置
     */
    public String getLocation() {
        return location;
    }

    /**
     * 位置
     */
    public void setLocation(String location) {
        this.location = location;
    }

    /**
     * 图片
     */
    public String getPic() {
        return pic;
    }

    /**
     * 图片
     */
    public void setPic(String pic) {
        this.pic = pic;
    }

    /**
     * 价格
     */
    public BigDecimal getPrice() {
        return price;
    }

    /**
     * 价格
     */
    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    /**
     * 状态
     */
    public String getStatus() {
        return status;
    }

    /**
     * 状态
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * 描述
     */
    public String getRemark() {
        return remark;
    }

    /**
     * 描述
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }

    /**
     * 补充内容
     */
    public String getExtra() {
        return extra;
    }

    /**
     * 补充内容
     */
    public void setExtra(String extra) {
        this.extra = extra;
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
        EnjoyFood other = (EnjoyFood) that;
        return (this.getId() == null ? other.getId() == null : this.getId().equals(other.getId()))
            && (this.getType() == null ? other.getType() == null : this.getType().equals(other.getType()))
            && (this.getName() == null ? other.getName() == null : this.getName().equals(other.getName()))
            && (this.getLocation() == null ? other.getLocation() == null : this.getLocation().equals(other.getLocation()))
            && (this.getPic() == null ? other.getPic() == null : this.getPic().equals(other.getPic()))
            && (this.getPrice() == null ? other.getPrice() == null : this.getPrice().equals(other.getPrice()))
            && (this.getStatus() == null ? other.getStatus() == null : this.getStatus().equals(other.getStatus()))
            && (this.getRemark() == null ? other.getRemark() == null : this.getRemark().equals(other.getRemark()))
            && (this.getExtra() == null ? other.getExtra() == null : this.getExtra().equals(other.getExtra()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
        result = prime * result + ((getType() == null) ? 0 : getType().hashCode());
        result = prime * result + ((getName() == null) ? 0 : getName().hashCode());
        result = prime * result + ((getLocation() == null) ? 0 : getLocation().hashCode());
        result = prime * result + ((getPic() == null) ? 0 : getPic().hashCode());
        result = prime * result + ((getPrice() == null) ? 0 : getPrice().hashCode());
        result = prime * result + ((getStatus() == null) ? 0 : getStatus().hashCode());
        result = prime * result + ((getRemark() == null) ? 0 : getRemark().hashCode());
        result = prime * result + ((getExtra() == null) ? 0 : getExtra().hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", type=").append(type);
        sb.append(", name=").append(name);
        sb.append(", location=").append(location);
        sb.append(", pic=").append(pic);
        sb.append(", price=").append(price);
        sb.append(", status=").append(status);
        sb.append(", remark=").append(remark);
        sb.append(", extra=").append(extra);
        sb.append("]");
        return sb.toString();
    }
}