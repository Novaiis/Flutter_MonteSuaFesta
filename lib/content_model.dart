class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({this.image, this.title, this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Selecione uma categoria',
      image: 'assets/categorias.gif',
      discription:
          "Dentre as categorias temos, DJ'S, Locais, Buffet's, Estruturas e iluminação e Mesas e Cadeiras"),
  UnbordingContent(
      title: 'Acompanhe nossas opções',
      image: 'assets/djs.gif',
      discription:
          "Veja todas as opções de parceiros que estão conosco, para maiores detalhes selecione um deles!"),
  UnbordingContent(
      title: 'Veja conteúdos e contatos',
      image: 'assets/alok.gif',
      discription:
          "Após selecionar um parceiro, você entra na pagina de Feed para maiores informações como fotos e uma descrição incrivel, depois de apreciar só entrar em contato no botão!"),
];
