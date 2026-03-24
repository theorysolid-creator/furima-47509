// turbo:load（ページ遷移時）と turbo:render（エラーでの再描画時）の両方で動くようにする
const calculate = () => {
  const priceInput = document.getElementById("item-price");
  if (priceInput) {
    priceInput.addEventListener("input", () => {
      const inputValue = priceInput.value;
      const addTaxDom = document.getElementById("add-tax-price");
      const tax = Math.floor(inputValue * 0.1);
      addTaxDom.innerHTML = tax;

      const profitDom = document.getElementById("profit");
      const profit = inputValue - tax;
      profitDom.innerHTML = Math.floor(profit);
    });
  }
};

window.addEventListener('turbo:load', calculate);
window.addEventListener('turbo:render', calculate);