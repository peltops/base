<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=false; section>
    <#if section = "header">
        <h2>${msg("emailVerifyTitle")}</h2>
        <p class="subtitle">${msg("emailVerifyInstruction1")}</p>
    <#elseif section = "form">
        <div class="info-content">
            <div class="info-icon-default">✉</div>
            
            <p class="info-message">
                ${msg("emailVerifyInstruction2")} 
                <#if user?? && user.email??>
                    <strong>${user.email}</strong>
                </#if>
            </p>
            
            <p class="info-message">
                ${msg("emailVerifyInstruction3")}
            </p>

            <#if pageRedirectUri?has_content>
                <div class="form-actions">
                    <a href="${pageRedirectUri}" class="btn btn-primary btn-block">
                        ${msg("backToApplication")}
                    </a>
                </div>
            <#else>
                <div class="form-actions">
                    <a href="${url.loginUrl}" class="btn btn-primary btn-block">
                        ${msg("backToLogin")}
                    </a>
                </div>
            </#if>

            <div class="form-footer">
                <p>
                    ${msg("emailVerifyResend")}
                    <a href="${url.loginAction}">${msg("doClickHere")}</a>
                </p>
            </div>
        </div>
    </#if>
</@layout.mainLayout>
