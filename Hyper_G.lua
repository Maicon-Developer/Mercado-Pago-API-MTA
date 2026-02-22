--[[ 
╔══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╗

                    ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗     ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
                    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
                    ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
                    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
                    ██║  ██║   ██║   ██║     ███████╗██║  ██║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
                    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                               
╚══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╝
--]]


Hyper_Config = {
     ['globals'] = {
          ['acess:token'] = 'APP_USR-'; -- https://www.mercadopago.com.br/developers/panel/app
          ['e-mail'] = '@gmail.com', -- Coloque aqui um email valido.
          ['teste:api'] = {
               ['command'] = 'testeapi';
               ['debug'] = false; -- Se deseja que o sistema mostre mensagens de debug no console, deixe como true.
               ['send'] = {
                    resname = getResourceName( getThisResource( ) ); -- Nome do resource.
                    description = 'Descrição do pagamento.'; -- Descrição do pagamento ( irá aparecer após a compra no mercado pago )
                    installments = 1; -- Quantidade de parcelamento ( deixe em 1 ).
                    amount = 100; -- Valor da cobrança.
                    position = { 1, 62, 195, 195 }; -- Posição do QR Code na tela do player.
                    loading = { 40, 100, 118, 118 }; -- Posição do Loading na tela do player.
                    color = { 255, 255, 255 }; -- Cor do loading.
                    email = 'teste@gmail.com'; -- E-mail de referência ( obrigatório )
                    external_reference = 'Account - teste Serial - 123'; -- Referência externa ( obrigatório )
                    width = 150; -- Largura do qrcode ( calculo respc ).
                    height = 150; -- Altura do qrcode ( calculo respc ).
                    x = 1.62; -- Posição parentX ( calculo respc ).
                    y = 3.4; -- Posição parentY ( calculo respc ).
                    checkout = { 'teste' }; -- Informações adicionais, para utilizar no retorno da função (getPayment).
               }
          };
          ['timer:payments'] = {
               ['timer'] = 10; -- Tempo de verificação do pagamento.
               ['format'] = 1000; -- Formato do tempo.
               ['verify'] = true -- Se deseja que o sistema verifique o pagamento automaticamente, deixe como true.
          };
          ['resoluções'] = { -- Tamanho da interface nas respectivas resoluções, adicione mais seguindo o padrão.
               [ 480 ] = 0.43;
               [ 576 ] = 0.5;
               [ 600 ] = 0.53;
               [ 720 ] = 0.8;
               [ 768 ] = 0.7;
               [ 900 ] = 1.1;
               [ 1050 ] = 1.15;
               [ 1080 ] = 1;
          };
     };
}
