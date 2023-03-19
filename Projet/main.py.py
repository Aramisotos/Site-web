import db
from flask import Flask, render_template, request, redirect, url_for, session
from passlib.context import CryptContext

password_ctx = CryptContext(schemes=['bcrypt'])

app = Flask(__name__)


@app.route("/accueil", methods = ['GET'])
def accueil():
    """
    page d'accueille avec choix événement redirection 
    inscription connexion puis recherche
    """

    choix_cat = request.args.get("categorie") 
    choix_tag = request.args.get("tag")


    #recupéraion des gatégories
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select nom from categorie;")
            lst_cat = cur.fetchall()

    #recuperation des tag
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select contenu from tag;")
            lst_tag = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select nom from meilleurEvent;")
            lst_event = cur.fetchall()

    return render_template("accueil.html", lst_cat = lst_cat, lst_tag = lst_tag, lst_event = lst_event)


@app.route("/form_connex")
def form_connexion():
  return render_template("form_connex.html")


@app.route("/form_inscription")
def form_inscription():
  return render_template("form_inscription.html")


@app.route("/connexion", methods = ['POST'])
def connexion():
    """
    Page pour se connecter pour l'admin ou un habitant
    avec session si habitant et redirection pour admin
    """

    mail = request.form.get("mail")
    mdp = request.form.get("mdp")

    if not mail or not mdp:
        return redirect(url_for("form_connexion"))
    
    
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select mdp, mail from habitant where mail = (%s);", (mail,))
            info_bd = cur.fetchone()

    
    for elem in info_bd:
        if mail == "admin.admin@gmail.com":
            if mdp == "admin":
                return redirect(url_for("admin"))
        if password_ctx.verify(mdp, elem):
            return redirect(url_for("accueil"))

    return redirect(url_for("form_connexion"))


@app.route("/inscription", methods = ['post'])
def inscription():
    """
    Pour permettre a un habitant de pouvoir s'inscrire a la bdd
    """
    nom = request.form.get("nom")
    prenom = request.form.get("prenom")
    mail = request.form.get("mail")
    mdp = request.form.get("mdp")
    date = request.form.get("date")

    if not nom or not prenom or not mail or not mdp or not date:
  
        return redirect(url_for("form_inscription"))

    hash_pw = password_ctx.hash(mdp) # calcul du hash, à stocker dans la base

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES (%s, %s, %s, %s, %s);", (nom, prenom, date, hash_pw, mail))
            return redirect(url_for("accueil"))
    
    return redirect(url_for("form_inscription"))

@app.route("/admin")
def admin():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select * from nombreParticipant;")
            stat_participant = cur.fetchall()        
    return render_template("admin.html", stat = stat_participant)




@app.route("/insert_tag")
def insert_tag():
    return render_template("insert_tag.html")


@app.route("/tag_insert")
def tag_insert():

    tag = request.form.get("tag")

    if not tag:
        return redirect(url_for("insert_tag"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("insert into tag(contenu) values (%s)", (tag,))




@app.route("/insert_event")
def insert_event():
    return render_template("insert_event.html")

@app.route("/event_insert", methods = ['post'])
def insert_event_insert():

    nom = request.form.get("nom")
    age_min = request.form.get("ageMin")
    age_max = request.form.get("ageMax")
    prix = request.form.get("prix")
    notice = request.form.get("notice")
    nb_personne = request.form.get("NbPersonne")

    if not nom or not age_max or not age_max or not notice or not nb_personne:
        return redirect(url_for("insert_event"))


    if not prix:
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("insert into evenement(nom, ageMin, ageMax, notice, NbPersonne) values (%s, %s, %s, %s, %s);", (nom, age_min, age_max, notice, nb_personne))


    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("insert into evenement(nom, ageMin, ageMax, prix, notice, NbPersonne) values (%s, %s, %s, %s, %s, %s);", (nom, age_min, age_max, prix, notice, nb_personne))


    return redirect(url_for("admin"))


@app.route("/insert_cat")
def insert_cat():
    return render_template("insert_cat.html")


@app.route("/cat_insert", methods = ['post'])
def cat_insert():
    cat = request.form.get("cat")

    if not cat:
        return redirect(url_for("insert_cat"))
    
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("insert into categorie values(nom) (%s)", (cat,))
    return redirect(url_for("admin"))


@app.route("/supp_tag")
def supp_tag():
    return render_template("supp_tag.html")


@app.route("/tag_supp", methods = ['post'])
def tag_supp():
    tag = request.form.get("tag")

    if not tag:
        return redirect(url_for("supp_tag"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("delete from tag where contenu = (%s);", (tag,))
    return redirect(url_for("admin"))


@app.route("/supp_event")
def supp_event():
    return render_template("supp_event.html")


@app.route("/event_supp", methods = ['post'])
def event_supp():
    event = request.form.get("event")

    if not event:
        return redirect(url_for("supp_event"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("delete from evenement where nom = (%s);",(event,))
    return redirect(url_for("admin"))

@app.route("/supp_cat")
def supp_cat():
    return render_template("supp_cat.html")


@app.route("/cat_supp",methods = ['post'])
def cat_supp():
    cat = request.form.get("cat")

    if not cat:
        return redirect(url_for("supp_cat"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("delete from categorie where nom = (%s);",(cat,))
    return redirect(url_for("admin"))


@app.route("/supp_inscription")
def hab_sup():
    return render_template("supp_inscription.html")

@app.route("/supp_pers", methods = ['post'])
def supp_hab():
    """
    Pour permettre a un habitant de pouvoir s'inscrire a la bdd
    """
    nom = request.form.get("nom")
    prenom = request.form.get("prenom")


    if not nom or not prenom:
        return redirect(url_for("supp_inscription"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("delete from habitant where nom = (%s) and prenom = (%s);",(nom, prenom))
    return redirect(url_for("admin"))


@app.route("/event")
def event():
    """"
    Affiche une page pour un évenement on récupere l'event pour
    afficher les photos description nom et date de l'event
    """

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select nom, photo, notice, ageMax, ageMin, prix, Nbpersonne from evenement natural left join partage natural join photo;")
            event = cur.fetchall()
    print(event)
    return render_template("event.html",lst_event = event)


@app.route("/resultat", methods = ['get'])
def resulat():
    tag = request.form.get("tag")
    cat = request.form.get("cat")

    if not tag:
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("select nom, ageMin, ageMax, prix, notice, NbPersonne, photo from categorie natural join possede natural join evenement natural join partage natural join photo where nom = (%s);", (cat,))
                event = cur.fetchall()
                return render_template("resultat.html", lst_event = event)

    elif not cat:
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("select nom, ageMin, ageMax, prix, notice, NbPersonne, photo from tag natural join classifie natural join evenememt natural join partage natural join photo where contenu = (%s);", (tag,))
                event = cur.fetchall()
                return render_template("resultat.html", lst_event = event)


    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select nom, ageMin, ageMax, prix, notice, NbPersonne, photo from categorie natural join possede natural join evenement natural join partage natural join photo where contenu = (%s);", (cat,))
            lst_event = cur.fetchall()
    return render_template("resultat.html", lst_event = event)

if __name__ == '__main__':
  app.run()


