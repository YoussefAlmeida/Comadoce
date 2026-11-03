# Coma Doce: site com animação na rolagem

Uma demo no estilo "a página se mexe com a rolagem": três capítulos (Brigadeiro, Bolos e Presentes). Em cada um, um vídeo avança frame a frame conforme a pessoa rola, com uma palavra gigante atrás do objeto.

**Hoje roda em modo prévia:** as animações são desenhadas em código. Quando você colocar os vídeos, o site troca sozinho, sem mexer no HTML.

```
scroll-demo/
├── index.html          ← o site inteiro (HTML + CSS + JS, sem build)
├── extract-frames.sh   ← vídeo → frames WebP + manifest.json
└── frames/
    ├── cacau/          ← capítulo 1 (desktop)
    ├── cacau-mobile/   ← capítulo 1 (celular, gerado junto)
    ├── calda/  ...
    └── ouro/   ...
```

---

## Passo a passo (do zero ao site pronto)

### 1. Gere a imagem inicial de cada cena
Use Nano Banana, Midjourney, GPT Image ou Flux. Se você tiver foto real do produto, melhor ainda: use a foto como referência.

### 2. Transforme a imagem em vídeo
Use Kling, Veo, Runway ou Higgsfield, no modo **image-to-video**. Sempre que a ferramenta deixar, mande o **primeiro e o último frame** (start/end frame). É o jeito mais confiável de controlar o movimento.

### 3. Extraia os frames
```bash
./extract-frames.sh brigadeiro.mp4 cacau
./extract-frames.sh bolo.mp4 calda
./extract-frames.sh bombom.mp4 ouro
```
Precisa ter o `ffmpeg` instalado. O script cria a versão desktop (1920px) e a mobile (900px).

### 4. Publique
Suba a pasta `scroll-demo/` inteira na Vercel, Netlify ou qualquer hospedagem estática.
> Abrir o `index.html` direto com duplo clique **não carrega os frames**, porque o navegador bloqueia o `manifest.json` fora de um servidor. Para testar no computador, rode `npx serve` ou `python3 -m http.server` dentro da pasta.

---

## As 5 regras do vídeo (é aqui que o resultado é decidido)

1. **Câmera travada.** Nenhum movimento de câmera: nada de zoom, pan ou dolly. Só o objeto se mexe.
2. **Fundo liso.** Branco puro `#FFFFFF` nas cenas claras (cacau, calda) e preto puro `#000000` na escura (ouro). O site "apaga" esse fundo com blend mode e a palavra gigante aparece atrás do objeto.
3. **Objeto no centro, ocupando uns 40% do quadro.** Com isso dá para cortar as laterais no celular sem perder o produto.
4. **De 4 a 6 segundos, 16:9, 1080p ou mais.** Em 30 fps isso dá de 120 a 180 frames por cena, o ponto ideal entre suavidade e peso.
5. **Sem texto, sem mãos, sem logo no vídeo.** Todo texto fica no HTML.

Se um vídeo vier com movimento de câmera, gere de novo. Não tem como consertar depois.

---

## Prompts por cena

Os prompts estão em inglês porque os modelos de vídeo respondem melhor assim.

### Capítulo 1: Cacau (brigadeiro se abrindo)

**Imagem inicial (frame 1)**
```
Studio product photo of a single gourmet Brazilian brigadeiro truffle covered in
chocolate sprinkles, sitting in a pleated gold paper candy cup, perfectly centered,
occupying 40% of the frame, pure white seamless background #FFFFFF, soft diffused
softbox lighting from top left, subtle soft shadow beneath, ultra sharp macro detail,
glossy chocolate, 16:9, no text, no props
```

**Imagem final (último frame)**: mesma cena, objeto desmontado
```
Same brigadeiro, exploded view: the truffle split horizontally in two halves floating
apart vertically, revealing a creamy fudgy chocolate interior, chocolate sprinkles
suspended in the air radiating outward, gold paper cup below, same camera, same
lighting, pure white seamless background #FFFFFF, 16:9, no text
```

**Vídeo (Kling, Veo ou Runway, com start e end frame)**
```
Locked-off static camera, no camera movement. The brigadeiro slowly splits
horizontally, the top half lifts and tilts slightly, chocolate sprinkles detach and
drift outward in slow motion, revealing the creamy interior. Smooth, elegant,
weightless motion, high-speed camera look. Pure white background stays constant.
Duration 5 seconds.
```

### Capítulo 2: Calda (ganache no bolo)

**Imagem inicial**
```
Studio product photo of a two-layer naked cake with visible red berry filling, on a
white porcelain cake plate, slightly elevated three-quarter view, centered, 40% of
frame, pure white seamless background #FFFFFF, soft diffused light, 16:9, no text
```

**Vídeo**
```
Locked-off static camera, no camera movement. A thin stream of glossy dark chocolate
ganache pours from above onto the center of the cake, spreads into a smooth glossy
pool covering the top, then slowly drips down the sides in irregular drips. Slow
motion, high-speed camera, realistic viscous liquid physics, glossy reflections.
Pure white background stays constant. Duration 5 seconds.
```

### Capítulo 3: Ouro (bombom e folha de ouro)

**Imagem inicial**
```
Luxury dark chocolate dome bonbon, glossy, centered, 40% of frame, pure black
seamless background #000000, dramatic low-key rim lighting in warm gold, fine
floating gold dust particles, 16:9, no text, no props
```

**Vídeo**
```
Locked-off static camera, no camera movement. Delicate edible gold leaf flakes float
in from all directions in a slow swirling motion and gently land on top of the
chocolate bonbon, settling into a crumpled gold leaf decoration. A soft highlight
sweeps across the glossy chocolate. Slow motion, elegant, luxurious. Pure black
background stays constant. Duration 5 seconds.
```

---

## Quando o texto atrás aparece "através" do objeto

O blend mode `multiply` deixa a palavra levemente visível dentro de objetos escuros. No chocolate isso quase não aparece. Se quiser que o objeto cubra a palavra 100%:

1. Remova o fundo de cada frame (Runway "Remove Background" em vídeo, ou o `rembg` em lote).
2. Exporte em WebP **com transparência**.
3. No `index.html`, apague o `data-blend` da cena.

---

## Para reaproveitar com outros clientes

Tudo que muda de um cliente para outro está no `index.html`:

| O quê | Onde |
|---|---|
| Cores e fontes | bloco `:root` no topo do `<style>` |
| Palavra gigante | `<div class="word"><span>Cacau</span></div>` |
| Textos de cada capítulo | `<div class="copy" data-in="0.10" data-out="0.46">`: os números dizem em que trecho da rolagem o texto aparece (0 = início, 1 = fim do capítulo) |
| Duração da rolagem | `.scene{height:420vh}`: mais alto deixa a animação mais lenta |
| Número de capítulos | copie um `<section class="scene">` e troque o `data-scene` pelo nome da pasta em `frames/` |
| WhatsApp | procure por `wa.me/` |

A animação desenhada em código (`DRAW.cacau`, `DRAW.calda`, `DRAW.ouro`) só serve de prévia. Para outro cliente, você não precisa dela: com os vídeos em `frames/`, ela nunca roda.

**Peso:** cada cena fica entre 4 e 10 MB no desktop e entre 1,5 e 3 MB no celular. O site mostra uma tela de carregamento com porcentagem enquanto baixa.
