{
  enable = true;
  settings = {
    mode = "drun";
    filter_rate = 100;
    matching = "contains";
    insensitive = true;
    term = "kitty";
    allow_images = true;
    parse_search = true;
    allow_markup = true;
    dmenu-parse_action = true;
    drun-display_generic = true;
    key_down = "Tab";
    key_expand = "Right";
    key_forward = "Down";
  };
  style = ''
  window {
    margin: 5px;
    border: 0px solid #444444;
    background-color: rgba(0, 0, 0, 0.0);
    /* opacity: 1; */
    font-family: FontAwesome;
}

@keyframes erscheinen {
    from {opacity: 0;}
      to {opacity: 1;}
}

#input {
    margin: 0px 0px 5px;
    border: 5px solid #b58900;
    background-color: rgb(7, 54, 66);
    border-radius: 20px;
    color : #fdf6e3;
}

#inner-box {
    margin: 0px;
    border: 0px solid #444444;
    background-color: rgba(68, 68, 68, 0.0);
}

/* #inner-box flowboxchild:nth-child(even) { */
/*     background-color: #555555; */
/* } */

#outer-box {
    margin: 0px;
    border: 0px solid rgb(203, 75, 22);
    background-color: rgba(0, 0, 0, 0.0);
}

#scroll {
    margin: 0px;
    border: 5px solid #586e75;
    border-radius: 0px;
    background-color: rgba(7, 54, 66, 0.9);
    /* animation: erscheinen 0.3s linear; */
}

#text {
    margin: 1px;
    border: 0px solid #44AA44;
    /* background-color: #444444; */
    color: #FFFFFF;
}

#selected {
    background-color: rgb(76, 162, 223);
}
  '';
}