<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="expan abbr ex"/>

    <!-- ============================================================
         TEMPLATE RADICE
         ============================================================ -->
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" lang="it">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <link rel="stylesheet" href="style.css" type="text/css"/>
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&amp;family=IM+Fell+English:ital@0;1&amp;display=swap" rel="stylesheet"/>
                <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
                <script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
                <script src="script.js"></script>
                <title>
                    <xsl:value-of select="//tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </title>
            </head>
            <body>
                <nav class="navbar">
    <div class="nav-container">
        <a href="#info-section" class="nav-logo">La Rassegna Settimanale</a>
        <ul class="nav-menu">
            
            <li class="nav-item dropdown">
                <a href="#" class="dropdown-toggle" onclick="return false;">Informazioni generali ▾</a>
                <ul class="dropdown-menu">
                    <li><a href="#info-section">Presentazione del progetto</a></li>
                    <li><a href="#glossary-section">Glossario dei Termini</a></li>
                </ul>
            </li>

            <li class="nav-item dropdown">
                <a href="#" class="dropdown-toggle" onclick="return false;">Articoli ▾</a>
                <ul class="dropdown-menu">
                    <li><a href="#TEI_scuolenormali-section" class="section-link">I locali delle scuole normali femminili (Vol. 3)</a></li>
                    <li><a href="#TEI_istruzionepubblica-section" class="section-link">La legge sull'istruzione pubblica (Vol. 5)</a></li>
                    <li><a href="#TEI_lavoromentale-section" class="section-link">Il lavoro mentale nelle scuole (Vol. 8)</a></li>
                </ul>
            </li>
            
            <li class="nav-item dropdown">
                <a href="#" class="dropdown-toggle" onclick="return false;">Bibliografia ▾</a>
                <ul class="dropdown-menu">
                    <li><a href="#TEI_BibliografiaAlfieri-section" class="section-link">Carlo Alfieri — Chi ha tempo non aspetti tempo (Vol. 3)</a></li>
                    <li><a href="#TEI_VirtuEducatrice-section" class="section-link">Domenico Caprile — Virtù Educatrice (Vol. 5)</a></li>
                </ul>
            </li>
            
            <li class="nav-item dropdown">
                <a href="#" class="dropdown-toggle" onclick="return false;">Notizie ▾</a>
                <ul class="dropdown-menu">
                    <li><a href="#TEI_NotizieVol3-section" class="section-link">Notizie Fascicolo 69 (Vol. 3)</a></li>
                    <li><a href="#TEI_NotizieVol5-section" class="section-link">Notizie Fascicolo 106 (Vol. 5)</a></li>
                    <li><a href="#TEI_NotizieVol8-section" class="section-link">Notizie Fascicolo 188 (Vol. 8)</a></li>
                </ul>
            </li>

            <li class="nav-item dropdown">
                <a href="#" class="dropdown-toggle" onclick="return false;">Link utili ▾</a>
                <ul class="dropdown-menu">
                    <li><a href="https://www.tei-c.org/" target="_blank">Sito Ufficiale TEI Consortium</a></li>
                    <li><a href="https://github.com/" target="_blank">Repository del Progetto</a></li>
                </ul>
            </li>
        </ul>
    </div>
</nav>
                <div class="site">

                    

                    <!-- SEZIONE INFORMAZIONI GENERALI -->
                    <section id="info-section" class="general-info visible-section">
                        <div class="main-logo-container">
                            <h1 class="corpus-title"><em>La Rassegna Settimanale</em></h1>
                            <p class="corpus-subtitle">Corpus digitale &#183; Selezione di articoli (1879&#8211;1881)</p>
                        </div>
                        <div id="document-info" class="document-info">
                            <h2>Informazioni sulla codifica</h2>
                            <div class="info-container">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader"/>
                            </div>
                        </div>
                        <div id="people-section" class="people-section">
                            <h2>Persone menzionate</h2>
                            <div class="people-grid">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listPerson/tei:person"/>
                            </div>
                        </div>
                        <div id="places-section" class="places-section">
                            <h2>Luoghi menzionati</h2>
                            <div class="people-grid">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listPlace/tei:place"/>
                            </div>
                        </div>
                    </section>

                    <!-- SEZIONI DEI SINGOLI TEI -->
                    <xsl:for-each select="/tei:teiCorpus/tei:TEI">
                        <section class="article-section hidden-section" id="{@xml:id}-section">
                            <article class="document">
                                <header class="document-header">
                                    <h2 class="title">
                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1]"/>
                                    </h2>
                                    <div class="article-header">
                                        <div class="publication-info">
                                            <div class="publication-info-line">
                                                <strong>Pubblicazione: </strong>
                                                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:title"/>
                                            </div>
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:publisher">
                                                <div class="publication-info-line">
                                                    <strong>Casa Editrice: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:publisher"/>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:pubPlace">
                                                <div class="publication-info-line">
                                                    <strong>Luogo di pubblicazione: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:pubPlace"/>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:date">
                                                <div class="publication-info-line">
                                                    <strong>Anno di pubblicazione: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:date"/>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='volume']">
                                                <div class="publication-info-line">
                                                    <strong>Volume: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='volume']"/>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='issue']">
                                                <div class="publication-info-line">
                                                    <strong>Fascicolo: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='issue']"/>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='page']">
                                                <div class="publication-info-line">
                                                    <strong>Pagina/e: </strong>
                                                    <xsl:choose>
                                                        <xsl:when test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='page']/@n">
                                                            <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='page']/@n"/>
                                                        </xsl:when>
                                                        <xsl:when test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='page']/@from">
                                                            <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='page']/@from"/>
                                                            <xsl:text>&#8211;</xsl:text>
                                                            <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope[@unit='page']/@to"/>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt">
                                                <div class="publication-info-line">
                                                    <strong>Codifica a cura di: </strong>
                                                    <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName">
                                                        <xsl:value-of select="."/>
                                                        <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                                                    </xsl:for-each>
                                                </div>
                                            </xsl:if>
                                        </div>
                                    </div>
                                </header>

                                <main class="main">
                                    <!-- LEGENDA -->
                                    <div class="legend">
                                        <h3>Legenda</h3>
                                        <div class="legend-grid">
                                            <div class="legend-item"><span class="legend-color" style="background-color:#fde68a;"></span><span>Persona reale</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#e5e7eb;"></span><span>Ruolo / persona immaginaria</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#f9a8d4;"></span><span>Luogo</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#86efac;"></span><span>Data</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#93c5fd;"></span><span>Organizzazione</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#c4b5fd;"></span><span>Termine disciplinare</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#fca5a5;"></span><span>Termine tematico</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#fdba74;"></span><span>Termine patologico</span></div>
                                            <div class="legend-item"><span class="legend-color" style="background-color:#a5f3fc;"></span><span>Altri termini</span></div>
                                            <div class="legend-item"><span class="legend-color legend-text" style="color:#b91c1c;font-weight:700;">orig</span><span>Forma originale</span></div>
                                            <div class="legend-item"><span class="legend-color legend-text" style="color:#15803d;font-weight:700;">reg</span><span>Forma regolarizzata</span></div>
                                            <div class="legend-item"><span class="legend-color legend-text" style="color:#c2410c;font-weight:700;">sic</span><span>Errore originale</span></div>
                                            <div class="legend-item"><span class="legend-color legend-text" style="color:#166534;font-weight:700;">corr</span><span>Correzione editoriale</span></div>
                                            <div class="legend-item"><span class="legend-color legend-text" style="color:#7e22ce;font-weight:700;">abbr</span><span>Abbreviazione</span></div>
                                            <div class="legend-item"><span class="legend-color legend-text" style="color:#0369a1;font-weight:700;">expan</span><span>Espansione</span></div>
                                        </div>
                                        <p class="legend-note">Clicca su una riga nel testo per evidenziarla nel facsimile, e viceversa.</p>
                                    </div>

                                    <!-- CONTENUTO: facsimile + testo -->
                                    <div class="document-content">
                                        <div class="facsimile-column" id="facsimile">
                                            <xsl:apply-templates select="tei:facsimile"/>
                                        </div>
                                        <div class="text-column" id="testo">
                                            <xsl:apply-templates select="tei:text"/>
                                        </div>
                                    </div>
                                </main>
                            </article>
                        </section>
                    </xsl:for-each>

                    <!-- SIDEBAR: GLOSSARIO -->
                    <aside class="sidebar">
                        <div id="glossary-section" class="glossary-section">
                            <h2>Glossario</h2>
                            <div class="glossary-container">
                                <xsl:for-each select="//tei:list[@type='glossary']">
                                    <div class="glossary-group" id="{@xml:id}">
                                        <xsl:if test="tei:head">
                                            <h3 class="glossary-group-title"><xsl:value-of select="tei:head"/></h3>
                                        </xsl:if>
                                        <xsl:for-each select="tei:label">
                                            <div class="glossary-card" id="{tei:term/@xml:id}">
                                                <h4>
                                                    <xsl:value-of select="tei:term"/>
                                                    <xsl:if test="tei:term/@type">
                                                        <span class="term-type"> (<xsl:value-of select="tei:term/@type"/>)</span>
                                                    </xsl:if>
                                                </h4>
                                                <div class="glossary-details">
                                                    <p class="definition-info">
                                                        <xsl:apply-templates select="following-sibling::tei:item[1]/tei:gloss/node()[not(self::tei:ref)]"/>
                                                        <xsl:for-each select="following-sibling::tei:item[1]/tei:gloss/tei:ref">
                                                            <a href="{@target}" class="entity-link"><xsl:value-of select="."/></a>
                                                            <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                                                        </xsl:for-each>
                                                    </p>
                                                </div>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </xsl:for-each>
                                <xsl:if test="//tei:taxonomy">
                                    <div class="glossary-group" id="taxonomy-section">
                                        <h3 class="glossary-group-title">Categorie tematiche</h3>
                                        <xsl:for-each select="//tei:taxonomy/tei:category">
                                            <div class="glossary-card" id="{@xml:id}">
                                                <h4><xsl:value-of select="@xml:id"/></h4>
                                                <div class="glossary-details">
                                                    <p class="definition-info"><xsl:value-of select="tei:catDesc"/></p>
                                                </div>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </xsl:if>
                            </div>
                        </div>
                    </aside>

                    <!-- FOOTER -->
                    <footer class="footer">
                        <span>Licenza <a href="https://creativecommons.org/licenses/by-nc/4.0/" target="_blank">CC BY-NC 4.0</a></span>
                        <span class="footer-sep"> &#183; </span>
                        <span>Rebecca Floris e Diletta Valenti &#8212; <xsl:value-of select="//tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher"/></span>
                    </footer>

                </div>
            </body>
        </html>
    </xsl:template>


    <!-- ============================================================
         TEMPLATE: teiHeader del corpus
         ============================================================ -->
    <xsl:template match="/tei:teiCorpus/tei:teiHeader">
        <div class="document-metadata">
            <div class="metadata-column">
                <h3>Edizione digitale</h3>
                <p><xsl:value-of select="tei:fileDesc/tei:editionStmt/tei:edition"/></p>
                <xsl:for-each select="tei:fileDesc/tei:titleStmt/tei:respStmt">
                    <p><strong><xsl:value-of select="tei:resp"/>:</strong>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="tei:persName">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                        </xsl:for-each>
                    </p>
                </xsl:for-each>
            </div>
            <div class="metadata-column">
                <h3>Pubblicazione</h3>
                <ul class="info-list">
                    <li><strong>Editore: </strong><xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:publisher"/></li>
                    <li><strong>Luogo: </strong><xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:pubPlace"/></li>
                    <li><strong>Anno: </strong><xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:date"/></li>
                    <xsl:if test="tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence">
                        <li><strong>Licenza: </strong>
                            <a href="{tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target}" target="_blank">
                                <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence"/>
                            </a>
                        </li>
                    </xsl:if>
                </ul>
            </div>
            <div class="metadata-column">
                <h3>Fonte originale</h3>
                <ul class="info-list">
                    <li><strong>Titolo: </strong><em><xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title"/></em></li>
                    <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date/@from">
                        <li><strong>Date: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date/@from"/>
                            <xsl:text>&#8211;</xsl:text>
                            <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date/@to"/>
                        </li>
                    </xsl:if>
                    <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:orgName">
                        <li><strong>Tipografo: </strong><xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:orgName"/></li>
                    </xsl:if>
                    <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:pubPlace">
                        <li><strong>Luogo: </strong><xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:pubPlace"/></li>
                    </xsl:if>
                </ul>
            </div>
            <div class="metadata-column">
                <h3>Progetto</h3>
                <p><xsl:value-of select="tei:encodingDesc/tei:projectDesc/tei:p"/></p>
                <xsl:if test="tei:profileDesc/tei:textClass/tei:keywords">
                    <p><strong>Parole chiave: </strong>
                        <xsl:for-each select="tei:profileDesc/tei:textClass/tei:keywords/tei:term">
                            <span class="keyword"><xsl:value-of select="."/></span>
                            <xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
                        </xsl:for-each>
                    </p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>


    <!-- ============================================================
         TEMPLATE: persone e luoghi (standOff)
         ============================================================ -->
    <xsl:template match="tei:person">
        <div class="person-card" id="{@xml:id}">
            <h3><xsl:apply-templates select="tei:persName[1]"/></h3>
            <div class="person-details">
                <xsl:if test="tei:birth">
                    <p class="birth-info"><strong>Nascita: </strong>
                        <xsl:value-of select="tei:birth/tei:date"/>
                        <xsl:if test="tei:birth/tei:placeName"><xsl:text>, </xsl:text><xsl:value-of select="tei:birth/tei:placeName"/></xsl:if>
                    </p>
                </xsl:if>
                <xsl:if test="tei:death">
                    <p class="death-info"><strong>Morte: </strong>
                        <xsl:value-of select="tei:death/tei:date"/>
                        <xsl:if test="tei:death/tei:placeName"><xsl:text>, </xsl:text><xsl:value-of select="tei:death/tei:placeName"/></xsl:if>
                    </p>
                </xsl:if>
                <xsl:if test="tei:occupation">
                    <p><strong>Occupazione: </strong><xsl:value-of select="tei:occupation"/></p>
                </xsl:if>
                <xsl:if test="tei:affiliation">
                    <p><strong>Affiliazione: </strong><xsl:value-of select="tei:affiliation"/></p>
                </xsl:if>
                <xsl:if test="tei:note">
                    <p class="note-info"><xsl:value-of select="tei:note"/></p>
                </xsl:if>
                <xsl:if test="tei:idno[@type='VIAF']">
                    <p>
                        <a href="https://viaf.org/viaf/{tei:idno[@type='VIAF']}" target="_blank" class="external-link">VIAF</a>
                        <xsl:if test="tei:idno[@type='Wikidata']">
                            <xsl:text> &#183; </xsl:text>
                            <a href="https://www.wikidata.org/wiki/{tei:idno[@type='Wikidata']}" target="_blank" class="external-link">Wikidata</a>
                        </xsl:if>
                    </p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:place">
        <div class="person-card" id="{@xml:id}">
            <h3><xsl:value-of select="tei:placeName"/></h3>
            <div class="person-details">
                <xsl:if test="tei:location/tei:geo"><p><strong>Coordinate: </strong><xsl:value-of select="tei:location/tei:geo"/></p></xsl:if>
                <xsl:if test="tei:country"><p><strong>Paese: </strong><xsl:value-of select="tei:country"/></p></xsl:if>
                <xsl:if test="tei:desc"><p><xsl:value-of select="tei:desc"/></p></xsl:if>
                <xsl:if test="tei:note"><p class="note-info"><xsl:value-of select="tei:note"/></p></xsl:if>
            </div>
        </div>
    </xsl:template>


    <!-- ============================================================
         TEMPLATE: facsimile
         ============================================================ -->
    <xsl:template match="tei:facsimile">
        <div class="facsimile-container">
            <xsl:for-each select="tei:surface">
                <div class="page-facsimile" id="facsimile-{@xml:id}">
                    <img src="{tei:graphic/@url}" alt="Facsimile" class="facsimile-image"
                         width="{substring-before(tei:graphic/@width,'px')}"
                         height="{substring-before(tei:graphic/@height,'px')}"/>
                    <svg class="overlay" xmlns="http://www.w3.org/2000/svg"
                         viewBox="0,0,{substring-before(tei:graphic/@width,'px')},{substring-before(tei:graphic/@height,'px')}">
                        <xsl:for-each select="tei:zone">
                            <rect x="{@ulx}" y="{@uly}"
                                  width="{@lrx - @ulx}" height="{@lry - @uly}"
                                  class="{translate(@corresp,'#','')}"/>
                        </xsl:for-each>
                    </svg>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>


    <!-- ============================================================
         TEMPLATE: struttura testuale
         ============================================================ -->
    <xsl:template match="tei:text">
        <div class="text-container"><xsl:apply-templates select="tei:body"/></div>
    </xsl:template>

    <xsl:template match="tei:body">
        <div class="article-body"><xsl:apply-templates/></div>
    </xsl:template>

    <xsl:template match="tei:div">
        <div class="text-div no-column" id="{@xml:id}" data-type="{@type}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:head">
        <h3 class="article-title" id="{@xml:id}">
            <xsl:choose>
                <xsl:when test="tei:title">
                    <xsl:apply-templates select="tei:title[@type='main']"/>
                    <xsl:if test="tei:title[@type='sub']">
                        <br/><span class="subtitle"><xsl:apply-templates select="tei:title[@type='sub']"/></span>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
            </xsl:choose>
        </h3>
    </xsl:template>

    <xsl:template match="tei:head/tei:title">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:p">
        <p class="text-paragraph" id="{@xml:id}"><xsl:apply-templates/></p>
    </xsl:template>

    <xsl:template match="tei:lb">
        <span class="line-break" id="{@xml:id}" data-line-break="true">
            <xsl:if test="@break='no'">
                <xsl:attribute name="data-break">no</xsl:attribute>
            </xsl:if>
        </span>
    </xsl:template>

    <xsl:template match="tei:pb">
        <div class="page-break" id="{@xml:id}">
            <span>&#8212; Pag. <xsl:value-of select="@n"/> &#8212;</span>
        </div>
    </xsl:template>

    <xsl:template match="tei:cb">
        <div class="column-break" id="{@xml:id}">
            <span class="column-number">Fine colonna <xsl:value-of select="@n"/></span>
        </div>
    </xsl:template>

    <xsl:template match="tei:fw">
        <div class="fw" id="{@xml:id}" data-place="{@place}" data-type="{@type}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:milestone">
        <hr class="milestone" id="{@xml:id}"/>
    </xsl:template>


    <!-- ============================================================
         TEMPLATE: entita nel testo
         ============================================================ -->
    <xsl:template match="tei:persName[ancestor::tei:text]">
        <xsl:choose>
            <xsl:when test="@type='imaginary'">
                <span class="entity persName imaginary" style="background-color:#d1d5db;">
                    <xsl:call-template name="entity-with-ref"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="entity persName" id="{@xml:id}" style="background-color:#fde68a;">
                    <xsl:call-template name="entity-with-ref"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:roleName">
        <span class="entity roleName" style="background-color:#e5e7eb;">
            <xsl:choose>
                <xsl:when test="@ref">
                    <a href="{@ref}" class="entity-link"><xsl:apply-templates/></a>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="tei:placeName[ancestor::tei:text]">
        <span class="entity placeName" style="background-color:#f9a8d4;">
            <xsl:call-template name="entity-with-ref"/>
        </span>
    </xsl:template>

    <xsl:template match="tei:orgName[ancestor::tei:text]">
        <span class="entity orgName" style="background-color:#93c5fd;">
            <xsl:if test="@type"><xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
            <xsl:choose>
                <xsl:when test="@ref"><a href="{@ref}" class="entity-link"><xsl:apply-templates/></a></xsl:when>
                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="tei:date[ancestor::tei:text]">
        <span class="entity date" style="background-color:#86efac;">
            <xsl:if test="@when"><xsl:attribute name="data-when"><xsl:value-of select="@when"/></xsl:attribute></xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- term: colori per tipo (tema, disciplina, patologia, altro) -->
    <xsl:template match="tei:term[ancestor::tei:text]">
        <xsl:variable name="t" select="@type"/>
        <span class="term entity-term">
            <xsl:attribute name="style">
                <xsl:choose>
                    <xsl:when test="$t='disciplina'">background-color:#c4b5fd;</xsl:when>
                    <xsl:when test="$t='tema'">background-color:#fca5a5;</xsl:when>
                    <xsl:when test="$t='patologia'">background-color:#fdba74;</xsl:when>
                    <xsl:otherwise>background-color:#a5f3fc;</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@ref"><a href="{@ref}" class="entity-link"><xsl:apply-templates/></a></xsl:when>
                <xsl:when test="@ana"><a href="{@ana}" class="entity-link"><xsl:apply-templates/></a></xsl:when>
                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="tei:foreign">
        <span class="entity foreign" lang="{@xml:lang}" style="font-style:italic;"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:measure">
        <span class="measure" data-quantity="{@quantity}"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:emphasis">
        <em><xsl:apply-templates/></em>
    </xsl:template>

    <xsl:template match="tei:ref">
        <a href="{@target}" class="entity-link"><xsl:apply-templates/></a>
    </xsl:template>

    <xsl:template name="entity-with-ref">
        <xsl:choose>
            <xsl:when test="@ref"><a href="{@ref}" class="entity-link"><xsl:apply-templates/></a></xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- ============================================================
         TEMPLATE: scelte editoriali
         ============================================================ -->
    <xsl:template match="tei:orig">
        <span class="orig-text" style="color:#b91c1c;" title="Forma originale"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:reg">
        <span class="reg-text" style="color:#15803d;" title="Forma regolarizzata"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:sic">
        <span class="sic-text" style="color:#c2410c;" title="Errore originale"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:corr">
        <span class="corr-text" style="color:#166534;" title="Correzione editoriale"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:abbr">
        <span class="abbr-text" style="color:#7e22ce;" title="Abbreviazione originale"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:expan">
        <span class="expan-text" style="color:#0369a1;" title="Espansione"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- ============================================================
         TEMPLATE: citazioni e liste
         ============================================================ -->
    <xsl:template match="tei:quote">
        <span class="quote">
            <xsl:if test="@xml:lang"><xsl:attribute name="lang"><xsl:value-of select="@xml:lang"/></xsl:attribute></xsl:if>
            <xsl:if test="@rend='italic'"><xsl:attribute name="style">font-style:italic;</xsl:attribute></xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:list[@type='unordered']">
        <ul><xsl:apply-templates/></ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li class="list-item"><xsl:apply-templates/></li>
    </xsl:template>

    <!-- titoli di opere in contesto bibliografico -->
    <xsl:template match="tei:bibl//tei:title | tei:sourceDesc//tei:title">
        <span class="work-title" style="font-style:italic;"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- persName/placeName/orgName/date fuori dal testo: solo testo -->
    <xsl:template match="tei:persName[not(ancestor::tei:text)]"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:placeName[not(ancestor::tei:text)]"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:orgName[not(ancestor::tei:text)]"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:date[not(ancestor::tei:text)]"><xsl:apply-templates/></xsl:template>

    <!-- Sopprimi metadati dall'output visibile -->
    <xsl:template match="tei:teiHeader"/>
    <xsl:template match="tei:facsimile[not(parent::tei:TEI)]"/>
    
    <!-- Note nel testo: simbolo cliccabile + popup -->
    <xsl:template match="tei:note[ancestor::tei:text]">
        <xsl:variable name="nid" select="generate-id()"/>
        <xsl:variable name="ntype" select="@type"/>
        <span class="note-trigger" data-note-id="{$nid}">
            <xsl:choose>
                <xsl:when test="$ntype='storica'">&#x2731;</xsl:when>
                <xsl:when test="$ntype='filologica'">&#x2020;</xsl:when>
                <xsl:when test="$ntype='biografica'">&#x2605;</xsl:when>
                <xsl:otherwise>&#x2217;</xsl:otherwise>
            </xsl:choose>
        </span>
        <span class="note-popup" id="note-{$nid}" data-note-type="{$ntype}">
            <span class="note-popup-header">
                <span class="note-popup-type">
                    <xsl:choose>
                        <xsl:when test="$ntype='storica'">Nota storica</xsl:when>
                        <xsl:when test="$ntype='filologica'">Nota filologica</xsl:when>
                        <xsl:when test="$ntype='biografica'">Nota biografica</xsl:when>
                        <xsl:otherwise>Nota</xsl:otherwise>
                    </xsl:choose>
                </span>
                <button class="note-popup-close">&#x00D7;</button>
            </span>
            <span class="note-popup-body"><xsl:apply-templates/></span>
        </span>
    </xsl:template>

    <!-- Note fuori dal testo (standOff, teiHeader): sopprimi -->
    <xsl:template match="tei:note[not(ancestor::tei:text)]"/>

    <!-- Colophon -->
    <xsl:template match="tei:div[@type='colophon']">
        <div class="colophon"><xsl:apply-templates/></div>
    </xsl:template>

</xsl:stylesheet>
