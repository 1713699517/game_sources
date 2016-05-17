
package com.test.sdk.common;

// 移动基地支付短信
public class CmccSmsPayInfo {

    // 可选参数，短信服务提供商（公司名称）。
    private String companyName;

    // 可选参数
    private String feeType;

    // 必需参数
    private String cpId;

    // 必需参数
    private String cpServiceId;

    // 必需参数
    private String consumeCode;

    // 可选参数
    private String fid;

    // 可选参数
    private String packageId;

    // 可选参数
    private String cpSign;

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getFeeType() {
        return feeType;
    }

    public void setFeeType(String feeType) {
        this.feeType = feeType;
    }

    public String getCpId() {
        return cpId;
    }

    public void setCpId(String cpId) {
        this.cpId = cpId;
    }

    public String getCpServiceId() {
        return cpServiceId;
    }

    public void setCpServiceId(String cpServiceId) {
        this.cpServiceId = cpServiceId;
    }

    public String getConsumeCode() {
        return consumeCode;
    }

    public void setConsumeCode(String consumeCode) {
        this.consumeCode = consumeCode;
    }

    public String getFid() {
        return fid;
    }

    public void setFid(String fid) {
        this.fid = fid;
    }

    public String getPackageId() {
        return packageId;
    }

    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }

    public String getCpSign() {
        return cpSign;
    }

    public void setCpSign(String cpSign) {
        this.cpSign = cpSign;
    }
}
