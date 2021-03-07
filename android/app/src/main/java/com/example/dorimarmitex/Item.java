package com.example.dorimarmitex;


public class Item {
  String nome;
  int tipo;

  public Item (String nome, int tipo){
    this.nome = nome;
    this.tipo = tipo;
  }

  public String getNome(){
    return this.nome;
  }

  public int getTipo(){
    return this.tipo;
  }
}
