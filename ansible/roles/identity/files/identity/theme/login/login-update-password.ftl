<#import "template.ftl" as layout>
<@layout.mainLayout active='' displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        <h2>${msg("updatePasswordTitle")}</h2>
        <p class="subtitle">${msg("updatePasswordDescription")}</p>
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="auth-form" action="${url.loginAction}" method="post">
            <input type="text" id="username" name="username" value="${username}" autocomplete="username" readonly="readonly" style="display:none;"/>
            <input type="password" id="password" name="password" autocomplete="current-password" style="display:none;"/>

            <#if isAppInitiatedAction??>
                <div class="form-group">
                    <label for="password-current" class="form-label">${msg("passwordCurrent")}</label>
                    <input type="password" 
                           id="password-current" 
                           class="form-input" 
                           name="password-current" 
                           autocomplete="current-password"
                           placeholder="${msg("passwordCurrent")}" />
                </div>
            </#if>

            <div class="form-group ${messagesPerField.printIfExists('password','has-error')}">
                <label for="password-new" class="form-label">${msg("passwordNew")}</label>
                <input type="password" 
                       id="password-new" 
                       class="form-input" 
                       name="password-new" 
                       autofocus 
                       autocomplete="new-password"
                       placeholder="${msg("passwordNew")}"
                       aria-invalid="<#if messagesPerField.existsError('password')>true</#if>" />
                <#if messagesPerField.existsError('password')>
                    <span class="input-error" aria-live="polite">
                        ${messagesPerField.get('password')?html}
                    </span>
                </#if>
            </div>

            <div class="form-group ${messagesPerField.printIfExists('password-confirm','has-error')}">
                <label for="password-confirm" class="form-label">${msg("passwordConfirm")}</label>
                <input type="password" 
                       id="password-confirm" 
                       class="form-input" 
                       name="password-confirm"
                       autocomplete="new-password"
                       placeholder="${msg("passwordConfirm")}"
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                <#if messagesPerField.existsError('password-confirm')>
                    <span class="input-error" aria-live="polite">
                        ${messagesPerField.get('password-confirm')?html}
                    </span>
                </#if>
            </div>

            <div class="form-actions">
                <#if isAppInitiatedAction??>
                    <button type="submit" class="btn btn-primary btn-block" name="login-update-password" value="Update">
                        ${msg("doSubmit")}
                    </button>
                    <button type="submit" class="btn btn-secondary btn-block" name="login-update-password" value="Skip" style="margin-top: 12px; background: var(--background); color: var(--text-color); border: 1px solid var(--border-color);">
                        ${msg("doSkip")}
                    </button>
                <#else>
                    <button type="submit" class="btn btn-primary btn-block" name="login-update-password">
                        ${msg("doSubmit")}
                    </button>
                </#if>
            </div>
        </form>

        <#if !isAppInitiatedAction??>
            <div class="form-footer">
                <p>
                    <a href="${url.loginUrl}">${msg("backToLogin")}</a>
                </p>
            </div>
        </#if>
    </#if>
</@layout.mainLayout>
