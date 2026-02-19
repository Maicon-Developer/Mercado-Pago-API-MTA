# 📦 Mercado Pago QR Code API Integration

🚀 **Public API release with improvements** — Este repositório contém a integração de API para gerar e verificar pagamentos via **QR Code (PIX)** utilizando a API do Mercado Pago em um ambiente de servidor *MTA:SA*. Ele foi projetado para ser **confiável, expansível e fácil de integrar** em servidores públicos.

A documentação detalhada de uso está disponível na nossa wiki:  
🔗 https://wiki.hyperscripts.com.br/documentacao/wiki/api-mercado-pago/qr-code

---

## 🧠 Sobre

A integração permite que você:

- 📱 Gere pagamentos do tipo **PIX** com QR Code (código dinâmico).
- 🔎 Verifique o status do pagamento de forma automática ou manual.
- 💰 Receba pagamentos automaticamente na sua conta Mercado Pago.
- 📩 Receba callbacks de status para entregar itens ou serviços ao jogador.

Os **QR Codes gerados** podem ser exibidos no cliente e os dados retornados incluem tanto o código para renderizar quanto um link de pagamento ou formato “copia e cola”.

A API utiliza o endpoint oficial do Mercado Pago para criação de pagamentos:  
`POST https://api.mercadopago.com/v1/payments` com o método `"pix"` e o header `X-Idempotency-Key` obrigatório. :contentReference[oaicite:0]{index=0}

---

## 📌 Funcionalidades

- ✔️ **Envio de requisições para gerar QR Code**  
  A função `sendRequestAPI(player, infos)` recebe os parâmetros necessários e faz o request ao Mercado Pago para gerar um pagamento via PIX/QR Code.

- ✔️ **Verificação de pagamento automática**  
  A cada intervalo configurado (`verify = true`), o sistema verifica todos os pagamentos pendentes usando `getRequestAPI`.

- ✔️ **Callback customizável por resource**  
  Ao solicitar um QR Code, você pode passar um `resname` (nome do seu resource) para receber retornos específicos como callbacks.

- ✔️ **Funções utilitárias**  
  - `getPaymentID(player)` — retorna o ID do pagamento e o código QR.
  - `closeQrcode(player)` — remove o QR Code do jogador.
  - `generateString(len)` — gera strings para idempotência de requisições.

---

## 💡 Como Usar

### 🧾 Exemplo de Comando para Gerar QR Code

Este comando, ao chamar a API, cria um pagamento via Pix e exibe o QR ao jogador:

```lua
addCommandHandler('gerarqrcode', function(player)
    local mercadopago = exports['[HS]API_Mercadopago']
    mercadopago:sendRequestAPI(player, {
        resname = getResourceName(getThisResource()),
        description = "Pagamento de teste",
        installments = 1,
        amount = 100,
        email = getAccountName(getPlayerAccount(player)).."@gmail.com",
        external_reference = "Account - "..getAccountName(getPlayerAccount(player)),
        -- opções visuais para exibir o QR Code
        position = {1, 62, 195, 195},
        loading = {40, 100, 118, 118},
        color = {255, 255, 255}
    })
end)
