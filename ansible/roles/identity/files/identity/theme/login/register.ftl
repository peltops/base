<#import "template.ftl" as layout>
<@layout.mainLayout active='register' displayMessage=!messagesPerField.existsError('username','email','password','password-confirm'); section>
    <#if section = "header">
        <h1 id="kc-page-title">Register</h1>
        <p class="subtitle">Enter your details to get started</p>
    <#elseif section = "form">
        <form id="kc-register-form" action="${url.registrationAction}" method="post">
            
            <#if !realm.registrationEmailAsUsername>
                <div class="form-group ${messagesPerField.printIfExists('username','has-error')}">
                    <label for="username">${msg("username")}</label>
                    <input type="text" 
                           id="username"
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
                <label for="email">${msg("email")}</label>
                <input type="email" 
                       id="email"
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
                <label for="password">${msg("password")}</label>
                <input type="password" 
                       id="password"
                       name="password"
                       autocomplete="new-password"
                       placeholder="Enter your password"
                       aria-invalid="<#if messagesPerField.existsError('password')>true</#if>" />
                <#if messagesPerField.existsError('password')>
                    <span class="input-error" aria-live="polite">
                        ${messagesPerField.get('password')?html}
                    </span>
                </#if>
            </div>

            <div class="form-group ${messagesPerField.printIfExists('password-confirm','has-error')}">
                <label for="password-confirm">${msg("passwordConfirm")}</label>
                <input type="password" 
                       id="password-confirm"
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

            <!-- Terms and Conditions Checkbox -->
            <div class="checkbox">
                <input type="checkbox" id="terms" name="terms" required />
                <label for="terms">I agree to Terms and Policies</label>
            </div>

            <#if recaptchaRequired??>
                <div class="form-group">
                    <div class="g-recaptcha" data-sitekey="${recaptchaSiteKey}"></div>
                </div>
            </#if>

            <div id="kc-form-buttons">
                <input type="hidden" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                <button type="submit" class="btn btn-primary">
                    ${msg("doRegister")}
                </button>
                <a href="${url.loginUrl}" class="btn btn-secondary">
                    Cancel
                </a>
            </div>
        </form>
        
        <div class="form-footer">
            <p>${msg("alreadyHaveAccount")} 
                <a href="${url.loginUrl}">${msg("doLogIn")}</a>
            </p>
        </div>
    </#if>
</@layout.mainLayout>
