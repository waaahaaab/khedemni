const nodemailer = require('nodemailer');

// Configuration du transporteur email
const transporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  port: process.env.EMAIL_PORT,
  secure: false, // true pour le port 465, false pour les autres ports
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
});

// Vérifier la connexion au serveur email
transporter.verify((error, success) => {
  if (error) {
    console.error('❌ Erreur de configuration email:', error);
  } else {
    console.log('✅ Serveur email prêt à envoyer des messages');
  }
});

// Fonction pour envoyer le code de réinitialisation
const sendResetCode = async (email, code, userName) => {
  const mailOptions = {
    from: `"Khedemni" <${process.env.EMAIL_FROM}>`,
    to: email,
    subject: 'Code de réinitialisation de mot de passe - Khedemni',
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background-color: #11224E; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
          .content { background-color: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }
          .code-box { background-color: #FF7A00; color: white; font-size: 32px; font-weight: bold; text-align: center; padding: 20px; margin: 20px 0; border-radius: 8px; letter-spacing: 8px; }
          .warning { color: #d9534f; font-size: 14px; margin-top: 20px; }
          .footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>🔐 Réinitialisation de mot de passe</h1>
          </div>
          <div class="content">
            <p>Bonjour <strong>${userName}</strong>,</p>
            <p>Vous avez demandé à réinitialiser votre mot de passe sur <strong>Khedemni</strong>.</p>
            <p>Voici votre code de vérification :</p>
            <div class="code-box">${code}</div>
            <p>Ce code est valide pendant <strong>15 minutes</strong>.</p>
            <p class="warning">⚠️ Si vous n'avez pas demandé cette réinitialisation, ignorez ce message.</p>
          </div>
          <div class="footer">
            <p>© 2024 Khedemni - Tous droits réservés</p>
          </div>
        </div>
      </body>
      </html>
    `,
    text: `Bonjour ${userName},\n\nVoici votre code de réinitialisation : ${code}\n\nCe code est valide pendant 15 minutes.\n\nSi vous n'avez pas demandé cette réinitialisation, ignorez ce message.\n\n© 2024 Khedemni`,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log('✅ Email envoyé:', info.messageId);
    return { success: true, messageId: info.messageId };
  } catch (error) {
    console.error('❌ Erreur envoi email:', error);
    return { success: false, error: error.message };
  }
};

module.exports = { sendResetCode };