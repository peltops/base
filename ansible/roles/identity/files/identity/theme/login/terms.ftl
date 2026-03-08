<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=false; section>
    <#if section = "header">
        <h2>${msg("termsTitle")}</h2>
    <#elseif section = "form">
        <div id="kc-terms-text" style="margin-bottom: 24px; padding: 20px; background: var(--background); border: 1px solid var(--border-color); max-height: 400px; overflow-y: auto; font-size: 14px; line-height: 1.6;">
            ${msg("termsText")?html}
        </div>
        
        <form class="auth-form" action="${url.loginAction}" method="POST">
            <div class="form-actions">
                <button type="submit" class="btn btn-primary btn-block" name="accept">
                    ${msg("doAccept")}
                </button>
                
                <button type="submit" class="btn btn-secondary btn-block" name="cancel" style="margin-top: 12px; background: var(--background); color: var(--text-color); border: 1px solid var(--border-color);">
                    ${msg("doDecline")}
                </button>
            </div>
        </form>
    </#if>
</@layout.mainLayout>
