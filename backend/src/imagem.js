import { ruim } from './erros.js';

const BASE64 = /^[A-Za-z0-9+/]+={0,2}$/;

/** Tipo da imagem pelos primeiros bytes (não confia no que o app diz). */
export function tipoDaImagem(b) {
  if (b.length > 3 && b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff) return 'image/jpeg';
  if (b.length > 8 && b.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) return 'image/png';
  if (b.length > 12 && b.toString('ascii', 0, 4) === 'RIFF' && b.toString('ascii', 8, 12) === 'WEBP') return 'image/webp';
  return null;
}

/**
 * Imagem opcional em base64 (capa de artigo, foto de perfil).
 * Devolve null se não veio; lança 400 se for inválida.
 */
export function lerImagem(bruto, maxBytes, nome = 'A imagem') {
  if (bruto === undefined || bruto === null || bruto === '') return null;
  if (typeof bruto !== 'string' || !BASE64.test(bruto)) throw ruim(`${nome} é inválida.`);
  const dados = Buffer.from(bruto, 'base64');
  if (dados.length > maxBytes) {
    throw ruim(`${nome} é grande demais (máximo de ${Math.round(maxBytes / 1024)} KB).`);
  }
  const tipo = tipoDaImagem(dados);
  if (!tipo) throw ruim(`${nome} precisa ser JPEG, PNG ou WebP.`);
  return { tipo, dados };
}

/** Envia a imagem guardada no banco, com cache longo (o endereço muda a cada troca). */
export function enviarImagem(res, img) {
  const bin = img.dados;
  res.set({
    'Content-Type': img.tipo,
    'Cache-Control': 'public, max-age=31536000, immutable',
    // O app (no navegador) roda em outro endereço: sem isto o helmet bloqueia.
    'Cross-Origin-Resource-Policy': 'cross-origin',
  });
  res.send(Buffer.from(bin.buffer ?? bin));
}
