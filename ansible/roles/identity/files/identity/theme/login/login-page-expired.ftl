<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=false; section>
    <#if section = "header">
        <h2>${msg("pageExpiredTitle")}</h2>
    <#elseif section = "form">
        <div class="info-content">
            <div class="warning-icon">⚠</div>
            
            <p class="info-message">
                ${msg("pageExpiredMsg1")}
            </p>
            
            <p class="info-message">
                ${msg("pageExpiredMsg2")} <a href="${url.loginRestartFlowUrl}">${msg("doClickHere")}</a>.
            </p>

            <div class="form-actions">
                <a href="${url.loginRestartFlowUrl}" class="btn btn-primary btn-block">
                    ${msg("doContinue")}
                </a>
            </div>

            <div class="form-footer">
                <p>
                    <a href="${url.loginUrl}">${msg("backToLogin")}</a>
                </p>
            </div>
        </div>
    </#if>
</@layout.mainLayout>
