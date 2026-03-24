const pay = () => {
  // PAY.JPの公開鍵をセットします。
  const payjp = Payjp('pk_test_9be04f9e5e73f22da4b3aab3');

  const elements = payjp.elements();

  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // 以前確認した view ファイルの id ("number-form"など) に、フォームを出現させます
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('charge-form')
  form.addEventListener("submit", (e) => {
    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
      } else {
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        const tokenObj = `<input value="${token}" name='token' type="hidden">`;
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
        }
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();
        document.getElementById("charge-form").submit();
    });
    e.preventDefault();
  });
};

// ページが読み込まれた時に上記の関数が実行されるようにします
window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);