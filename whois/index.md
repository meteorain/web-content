<style>
  my-email::after {
    content: attr(data-domain);
  }
  my-email::before {
    content: attr(data-user) "\0040";
  }
</style>
__*Vivian* LIU__ / 📧<my-email data-user="liuweinan85" data-domain="gmail.com"></my-email>