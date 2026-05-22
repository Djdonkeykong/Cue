import SwiftUI

// Email OTP sheet — shared by sign-up and sign-in flows.
struct EmailAuthView: View {
    @EnvironmentObject private var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss

    let isSignIn: Bool

    @State private var email = ""
    @State private var otpCode = ""
    @State private var step: Step = .email
    @State private var errorMessage: String? = nil
    @State private var resendCooldown: Int = 0
    @State private var isSending = false
    @State private var isVerifying = false
    @State private var cursorVisible = true
    @FocusState private var emailFocused: Bool
    @State private var otpFocused = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    enum Step { case email, otp }

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                sheetHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 22)
                    .padding(.bottom, 28)

                if step == .email {
                    emailStep
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ))
                } else {
                    otpStep
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .trailing)
                        ))
                }

                Spacer()
            }
        }
        .onReceive(timer) { _ in
            if resendCooldown > 0 { resendCooldown -= 1 }
        }
    }

    // MARK: - Header

    private var sheetHeader: some View {
        HStack(alignment: .top) {
            Text(step == .email ? "Continue with email" : "Check your inbox")
                .font(.skin(.title3, weight: .semibold))
                .foregroundStyle(SkinTheme.primaryText.opacity(0.84))
                .animation(.none, value: step)

            Spacer()

            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(SkinTheme.secondaryText)
                    .frame(width: 38, height: 38)
                    .background(SkinTheme.elevatedSurface, in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Email step

    private var emailStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("We'll send a 6-digit code to sign you in or create your account.")
                .font(.skin(.body))
                .foregroundStyle(SkinTheme.secondaryText)
                .lineSpacing(3)

            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.skin(.caption, weight: .medium))
                    .foregroundStyle(SkinTheme.secondaryText)

                TextField("", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                    .focused($emailFocused)
                    .submitLabel(.go)
                    .onSubmit { sendCode() }
                    .onChange(of: email) { _, v in
                        if v.count > 254 { email = String(v.prefix(254)) }
                    }
                    .padding(16)
                    .background(SkinTheme.elevatedSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                emailFocused ? SkinTheme.primaryDeep : Color.primary.opacity(0.10),
                                lineWidth: emailFocused ? 1.5 : 1
                            )
                    }
            }

            if let error = errorMessage {
                Text(error)
                    .font(.skin(.caption))
                    .foregroundStyle(SkinTheme.dangerColor)
            }

            sendButton
        }
        .padding(.horizontal, 20)
        .onAppear { emailFocused = true }
    }

    private var sendButton: some View {
        Button {
            sendCode()
        } label: {
            ZStack {
                if isSending {
                    ProgressView().tint(.white)
                } else {
                    Text("Send code")
                        .font(.skin(.body, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isSending ? SkinTheme.primaryDeep.opacity(0.6) : SkinTheme.primaryDeep)
            .clipShape(Capsule())
        }
        .disabled(isSending)
    }

    // MARK: - OTP step

    private var otpStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enter the 6-digit code we sent to \(email).")
                .font(.skin(.body))
                .foregroundStyle(SkinTheme.secondaryText)
                .lineSpacing(3)

            otpBoxes

            if let error = errorMessage {
                Text(error)
                    .font(.skin(.caption))
                    .foregroundStyle(SkinTheme.dangerColor)
            }

            verifyButton

            HStack(spacing: 4) {
                Text("Didn't get it?")
                    .foregroundStyle(SkinTheme.secondaryText)
                Button(resendCooldown > 0 ? "Resend in \(resendCooldown)s" : "Resend") {
                    guard resendCooldown == 0 else { return }
                    sendCode(isResend: true)
                }
                .foregroundStyle(resendCooldown > 0 ? SkinTheme.secondaryText : SkinTheme.primaryDeep)
                .fontWeight(.semibold)
                .disabled(resendCooldown > 0)
            }
            .font(.skin(.subheadline))
            .padding(.top, 8)

            Button {
                withAnimation(.easeInOut(duration: 0.28)) { step = .email }
                otpCode = ""
                errorMessage = nil
            } label: {
                Text("Change email")
                    .font(.skin(.subheadline))
                    .foregroundStyle(SkinTheme.secondaryText)
            }
        }
        .padding(.horizontal, 20)
        .onAppear { otpFocused = true }
        .onDisappear { otpFocused = false }
    }

    private var verifyButton: some View {
        Button {
            verify()
        } label: {
            ZStack {
                if isVerifying {
                    ProgressView().tint(.white)
                } else {
                    Text("Verify")
                        .font(.skin(.body, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(otpCode.count < 6 ? SkinTheme.primaryDeep.opacity(0.4) : SkinTheme.primaryDeep)
            .clipShape(Capsule())
        }
        .disabled(otpCode.count < 6 || isVerifying)
    }

    // MARK: - OTP boxes

    private var otpBoxes: some View {
        ZStack {
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    let char: String = index < otpCode.count
                        ? String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: index)])
                        : ""
                    let isActive = index == otpCode.count

                    Text(char)
                        .font(.system(size: 22, weight: .semibold, design: .monospaced))
                        .foregroundStyle(SkinTheme.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(SkinTheme.elevatedSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(
                                    isActive ? SkinTheme.primaryDeep : Color.primary.opacity(0.10),
                                    lineWidth: isActive ? 1.5 : 1
                                )
                        }
                        .overlay {
                            if isActive && otpFocused {
                                Rectangle()
                                    .fill(SkinTheme.primaryDeep)
                                    .frame(width: 2, height: 24)
                                    .opacity(cursorVisible ? 1 : 0)
                            }
                        }
                }
            }

            OTPAutofillField(text: $otpCode, onFilled: verify)
                .task(id: otpFocused) {
                    guard otpFocused else { return }
                    try? await Task.sleep(nanoseconds: 350_000_000)
                    guard !Task.isCancelled else { return }
                    cursorVisible = true
                    while !Task.isCancelled {
                        try? await Task.sleep(nanoseconds: 530_000_000)
                        withAnimation(.easeInOut(duration: 0.12)) { cursorVisible.toggle() }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .opacity(0.011)
        }
    }

    // MARK: - Actions

    private func sendCode(isResend: Bool = false) {
        errorMessage = nil
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter your email."
            return
        }
        isSending = true
        Task {
            do {
                try await authManager.sendOTP(email: trimmed, shouldCreateUser: !isSignIn)
                isSending = false
                otpCode = ""
                resendCooldown = 60
                withAnimation(.easeInOut(duration: 0.28)) { step = .otp }
            } catch {
                isSending = false
                if isSignIn {
                    let msg = error.localizedDescription.lowercased()
                    let isRateLimit = msg.contains("after") || msg.contains("seconds")
                        || msg.contains("rate") || msg.contains("too many")
                        || msg.contains("security purposes")
                    errorMessage = isRateLimit
                        ? "Too many attempts. Please wait before trying again."
                        : "No account found with this email. Tap \"Sign up\" to create one."
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func verify() {
        errorMessage = nil
        guard otpCode.count == 6 else { return }
        isVerifying = true
        Task {
            do {
                try await authManager.verifyOTP(email: email, token: otpCode)
                isVerifying = false
                dismiss()
            } catch {
                isVerifying = false
                errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - OTP autofill field

// UIViewRepresentable because SwiftUI TextField never fires onChange for autofill-delivered text.
// UIControl.editingChanged fires for both typed input and QuickType/autofill.
private struct OTPAutofillField: UIViewRepresentable {
    @Binding var text: String
    var onFilled: () -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.textContentType = .oneTimeCode
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.tintColor = .clear
        field.textColor = .clear
        field.backgroundColor = .clear
        field.borderStyle = .none
        field.delegate = context.coordinator
        field.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textChanged(_:)),
            for: .editingChanged
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { field.becomeFirstResponder() }
        return field
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        context.coordinator.parent = self
        if uiView.text != text { uiView.text = text }
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: OTPAutofillField
        init(_ parent: OTPAutofillField) { self.parent = parent }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string.isEmpty { return true }
            return string.allSatisfy { $0.isNumber }
        }

        @objc func textChanged(_ textField: UITextField) {
            let digits = (textField.text ?? "").filter { $0.isNumber }
            let clamped = String(digits.prefix(6))
            if textField.text != clamped { textField.text = clamped }
            parent.text = clamped
            if clamped.count == 6 {
                DispatchQueue.main.async { self.parent.onFilled() }
            }
        }
    }
}
