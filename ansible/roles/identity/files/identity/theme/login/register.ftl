<#import "template.ftl" as layout>
<@layout.mainLayout active='register' displayMessage=!messagesPerField.existsError('username','email','password','password-confirm'); section>
    <#if section = "header">
        <h2>Create Your Account</h2>
        <p class="subtitle">Enter your details to get started</p>
    <#elseif section = "form">
        <form id="kc-register-form" class="auth-form" action="${url.registrationAction}" method="post">
            
            <#if !realm.registrationEmailAsUsername>
                <div class="form-group ${messagesPerField.printIfExists('username','has-error')}">
                    <label for="username" class="form-label">${msg("username")}</label>
                    <input type="text" 
                           id="username" 
                           class="form-input" 
                           name="username"
                           value="${(register.formData.username!'')}" 
                           autocomplete="username"
                           placeholder="Choose a username"
                           aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                    <#if messagesPerField.existsError('username')>
                        <span class="input-error" aria-live="polite">
                            ${messagesPerField.get('username')?html}
                        </span>
                    </#if>
                </div>
            </#if>

            <div class="form-group ${messagesPerField.printIfExists('email','has-error')}">
                <label for="email" class="form-label">${msg("email")}</label>
                <input type="email" 
                       id="email" 
                       class="form-input" 
                       name="email"
                       value="${(register.formData.email!'')}" 
                       autocomplete="email"
                       placeholder="Enter your email"
                       aria-invalid="<#if messagesPerField.existsError('email')>true</#if>" />
                <#if messagesPerField.existsError('email')>
                    <span class="input-error" aria-live="polite">
                        ${messagesPerField.get('email')?html}
                    </span>
                </#if>
            </div>

            <div class="form-group ${messagesPerField.printIfExists('password','has-error')}">
                <label for="password" class="form-label">${msg("password")}</label>
                <input type="password" 
                       id="password" 
                       class="form-input" 
                       name="password"
                       autocomplete="new-password"
                       placeholder="Create a password"
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
                       placeholder="Confirm your password"
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                <#if messagesPerField.existsError('password-confirm')>
                    <span class="input-error" aria-live="polite">
                        ${messagesPerField.get('password-confirm')?html}
                    </span>
                </#if>
            </div>

            <#if recaptchaRequired??>
                <div class="form-group">
                    <div class="g-recaptcha" data-sitekey="${recaptchaSiteKey}"></div>
                </div>
            </#if>

            <div class="form-actions">
                <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                <button type="submit" class="btn btn-primary btn-block">
                    ${msg("doRegister")}
                </button>
            </div>
        </form>
        
        <div class="form-footer">
            <p>${msg("alreadyHaveAccount")} 
                <a href="${url.loginUrl}">${msg("doLogIn")}</a>
            </p>
        </div>
    </#if>
</@layout.mainLayout>
