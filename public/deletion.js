// Seek Player 帳號/資料刪除頁共用邏輯。
// 頁面以 <body data-function="..."> 指定要呼叫的 Cloud Function:
//   delete_account      → 刪除雲端資料 + Auth 帳號
//   delete_account_data → 只刪除雲端資料,保留帳號
// Firebase 設定由 Hosting 保留路徑 /__/firebase/init.js 自動初始化。

// 與 functions/main.py 的 _REGION、app 端 _functionsRegion 一致。
var FUNCTIONS_REGION = 'asia-east1';

document.addEventListener('DOMContentLoaded', function () {
  var fnName = document.body.dataset.function;
  var auth = firebase.auth();
  var callable = firebase.app().functions(FUNCTIONS_REGION).httpsCallable(fnName);

  var loadingEl = document.getElementById('loading');
  var signinEl = document.getElementById('signin');
  var confirmEl = document.getElementById('confirm');
  var doneEl = document.getElementById('done');
  var errorEl = document.getElementById('error');
  var userIdEl = document.getElementById('user-id');
  var ackEl = document.getElementById('ack');
  var deleteBtn = document.getElementById('delete-btn');

  // 成功後鎖定畫面,避免 onAuthStateChanged(登出)又把登入表單顯示回來。
  var finished = false;

  function showError(message) {
    errorEl.textContent = message;
    errorEl.hidden = false;
  }

  function clearError() {
    errorEl.hidden = true;
  }

  auth.onAuthStateChanged(function (user) {
    loadingEl.hidden = true;
    if (finished) return;
    if (user) {
      userIdEl.textContent = user.email || user.phoneNumber || user.uid;
      signinEl.hidden = true;
      confirmEl.hidden = false;
    } else {
      signinEl.hidden = false;
      confirmEl.hidden = true;
      // 重置手機流程(若上次登入走到驗證碼步驟)。
      var phoneFormEl = document.getElementById('phone-form');
      var codeFormEl = document.getElementById('code-form');
      if (codeFormEl && !codeFormEl.hidden) {
        codeFormEl.hidden = true;
        phoneFormEl.hidden = false;
      }
    }
  });

  document.getElementById('google-btn').addEventListener('click', function () {
    clearError();
    auth.signInWithPopup(new firebase.auth.GoogleAuthProvider()).catch(function (e) {
      showError(e.message || String(e));
    });
  });

  document.getElementById('email-form').addEventListener('submit', function (ev) {
    ev.preventDefault();
    clearError();
    var email = document.getElementById('email').value;
    var password = document.getElementById('password').value;
    auth.signInWithEmailAndPassword(email, password).catch(function (e) {
      showError(e.message || String(e));
    });
  });

  // 手機 OTP 登入:點開才渲染 reCAPTCHA(Web 端 phone auth 必要)。
  var phoneToggle = document.getElementById('phone-toggle');
  var phoneSection = document.getElementById('phone-section');
  var phoneForm = document.getElementById('phone-form');
  var codeForm = document.getElementById('code-form');
  var recaptchaVerifier = null;
  var confirmationResult = null;

  phoneToggle.addEventListener('click', function () {
    phoneToggle.hidden = true;
    phoneSection.hidden = false;
    if (!recaptchaVerifier) {
      recaptchaVerifier = new firebase.auth.RecaptchaVerifier('recaptcha-container', { size: 'normal' });
      recaptchaVerifier.render();
    }
  });

  phoneForm.addEventListener('submit', function (ev) {
    ev.preventDefault();
    clearError();
    var phone = document.getElementById('phone').value.trim();
    auth.signInWithPhoneNumber(phone, recaptchaVerifier)
      .then(function (result) {
        confirmationResult = result;
        phoneForm.hidden = true;
        codeForm.hidden = false;
      })
      .catch(function (e) {
        showError(e.message || String(e));
        // reCAPTCHA token 是一次性的,失敗後重置才能重送。
        recaptchaVerifier.render().then(function (id) {
          if (window.grecaptcha) grecaptcha.reset(id);
        });
      });
  });

  codeForm.addEventListener('submit', function (ev) {
    ev.preventDefault();
    clearError();
    var code = document.getElementById('sms-code').value.trim();
    confirmationResult.confirm(code).catch(function (e) {
      showError(e.message || String(e));
    });
  });

  document.getElementById('signout-btn').addEventListener('click', function () {
    clearError();
    ackEl.checked = false;
    deleteBtn.disabled = true;
    auth.signOut();
  });

  ackEl.addEventListener('change', function () {
    deleteBtn.disabled = !ackEl.checked;
  });

  deleteBtn.addEventListener('click', function () {
    clearError();
    deleteBtn.disabled = true;
    deleteBtn.textContent = deleteBtn.dataset.busyLabel;
    callable()
      .then(function () {
        finished = true;
        confirmEl.hidden = true;
        doneEl.hidden = false;
        // 兩種情境都登出:刪帳號後 token 已失效;只刪資料則避免共用電腦殘留登入。
        return auth.signOut().catch(function () {});
      })
      .catch(function (e) {
        deleteBtn.disabled = false;
        deleteBtn.textContent = deleteBtn.dataset.idleLabel;
        showError(e.message || String(e));
      });
  });
});
