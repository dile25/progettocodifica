/* ============================================================
   script_FlorisValenti.js — La Rassegna Settimanale · Corpus digitale
   Funzionalità invariate rispetto all'originale, con correzioni
   e adattamenti alla struttura del nuovo XML/XSLT.
   ============================================================ */

$(document).ready(function () {
    initializeNavigation();      // menu a tendina + navigazione tra sezioni
    setupTextLines();            // divide il testo in righe cliccabili
    initializeHighlighting();    // verifica i collegamenti testo-immagine
    setupZoneHighlighting();     // click zone SVG ↔ righe di testo
    setupFormWork();             // fw (intestazioni di pagina) → text-line
    setupReferences();           // placeholder gestione ref
    setupEntityLinks();          // popup per persone, luoghi, termini
    setupColumnBreaks();         // multi-column per i cb

    // Smooth scroll per link anchor (esclusi entity-link e note-ref)
    $('a[href^="#"]').not('.entity-link, .note-ref').on('click', function (e) {
        e.preventDefault();
        var target = $(this.hash);
        if (target.length) {
            $('html, body').scrollTop(target.offset().top - 70);
        }
    });

    // Calcola le zone SVG dopo che le immagini sono caricate
    setTimeout(resizeZones, 300);
    $(window).on('load', function () { resizeZones(); });
});


/* ============================================================
   NAVIGAZIONE — menu a tendina e switch tra sezioni
   ============================================================ */
function initializeNavigation() {

    // ── Vecchia tendina (retrocompatibilità) ──
    $('#navigation-fab button').on('click', function (e) {
        $('.navigation-dropdown').toggleClass('active');
        e.stopPropagation();
    });
    $('.navigation-dropdown').on('click', function (e) { e.stopPropagation(); });

    // ── Navbar orizzontale: apri/chiudi dropdown ──
    $(document).on('click', '.dropdown-toggle', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var item = $(this).closest('.nav-item');
        var isOpen = item.hasClass('open');
        $('.nav-item').removeClass('open');
        if (!isOpen) item.addClass('open');
    });

    // ── Click su qualsiasi link di navigazione ──
    $(document).on('click', '.section-link, .dropdown-menu a[href^="#"]', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var href = $(this).attr('href');
        if (!href) return;
        $('.nav-item').removeClass('open');
        $('.navigation-dropdown').removeClass('active');
        navigateTo(href);
        var glossaryId = $(this).data('glossary-id');
        if (glossaryId) {
            $('.glossary-group').hide();
            $('#' + glossaryId).show();
        }
    });

    // ── Click sul logo ──
    $(document).on('click', '.nav-logo', function (e) {
        e.preventDefault();
        $('.nav-item').removeClass('open');
        showSection('#info-section');
        $('html, body').scrollTop(0);
    });

    // ── Pulsanti avanti/indietro (se presenti) ──
    $('#back-fab button, #forward-fab button').on('click', function () {
        var sections = $('.article-section, #info-section');
        var visible  = $('.visible-section');
        var current  = sections.index(visible);
        var next     = $(this).parent().attr('id') === 'back-fab'
                       ? (current - 1 + sections.length) % sections.length
                       : (current + 1) % sections.length;
        visible.removeClass('visible-section').addClass('hidden-section');
        sections.eq(next).removeClass('hidden-section').addClass('visible-section');
        $('html, body').scrollTop(0);
    });
}

// Navigazione centralizzata
function navigateTo(href) {
    var infoAnchors = ['#document-info', '#people-section', '#places-section', '#glossary-section', '#info-section'];
    if (infoAnchors.indexOf(href) !== -1) {
        showSection('#info-section');
        if (href !== '#info-section') {
            setTimeout(function () {
                var t = $(href);
                if (t.length) $('html, body').scrollTop(t.offset().top - 60);
            }, 100);
        }
    } else {
        // href tipo '#TEI_scuolenormali' oppure '#TEI_scuolenormali-section'
        var id = href.replace(/^#/, '');
        var sectionId = id.endsWith('-section') ? id : id + '-section';
        showSection('#' + sectionId);
        $('html, body').scrollTop(0);
    }
}

// Mostra una sezione e nasconde le altre
function showSection(sectionSelector) {
    $('.visible-section').removeClass('visible-section').addClass('hidden-section');
    var sec = $(sectionSelector);
    if (!sec.length && sectionSelector.charAt(0) !== '#') {
        sec = $('#' + sectionSelector);
    }
    sec.removeClass('hidden-section').addClass('visible-section');
}

// Chiude il dropdown cliccando fuori
$(document).on('click', function () {
    $('.navigation-dropdown').removeClass('active');
    $('.nav-item').removeClass('open');
});


/* ============================================================
   RIGHE DI TESTO — suddivide i paragrafi in div.text-line
   ============================================================ */
function setupTextLines() {
    $('.text-paragraph, .list-item, p, .article-body > *, .text-column > *').each(function () {
        var container = $(this);
        if (container.hasClass('processed-lines') ||
            container.hasClass('line-break') ||
            container.hasClass('text-line')) return;
        container.addClass('processed-lines');
        processContainerLines(container);
    });

    // column-break e page-break sono già righe di per sé
    $('.column-break, .page-break').each(function () {
        if (!$(this).hasClass('text-line')) $(this).addClass('text-line');
    });

    // fw: intestazioni di pagina
    $('.fw').each(function () {
        if (!$(this).hasClass('text-line') && !$(this).hasClass('processed-lines')) {
            $(this).addClass('text-line processed-lines');
        }
    });
}

// Elabora un container dividendolo in righe sui lb TEI
function processContainerLines(container) {
    var lineBreaks = container.find('lb, .line-break');
    if (lineBreaks.length === 0) {
        container.addClass('text-line');
        if (!container.attr('id')) container.attr('id', 'line-' + generateUniqueId());
        return 0;
    }

    var containerId   = container.attr('id') || 'container-' + generateUniqueId();
    var tempContainer = $('<div>').html(container.html());
    var lineNumber    = 1;

    tempContainer.find('lb, .line-break').each(function () {
        var lb     = $(this);
        var lbId   = lb.attr('id') || (containerId + '-lb-' + lineNumber);
        var marker = '<span class="line-marker" data-line-id="' + lbId + '"></span>';
        if (lb.attr('data-break') === 'no') marker = '-' + marker;
        lb.before(marker);
        lineNumber++;
    });

    // Separa sugli span marcatori
    var parts = tempContainer.html().split(/<span class="line-marker"[^>]*><\/span>/);
    container.empty();

    parts.forEach(function (part, index) {
        if (!part.trim()) return;
        // Recupera l'id del lb se presente nella parte
        var lbMatch = part.match(/<(?:lb|span[^>]*class="line-break"[^>]*)\s+id="([^"]+)"/);
        var lineId  = lbMatch ? lbMatch[1] : (containerId + '-line-' + (index + 1));
        // Rimuove i tag lb e span.line-break residui
        var clean   = part.replace(/<lb[^>]*>|<span[^>]*class="line-break"[^>]*><\/span>/g, '');
        container.append($('<div class="text-line" id="' + lineId + '">' + clean + '</div>'));
    });

    container.removeClass('text-paragraph list-item');
    return lineNumber - 1;
}

// Contatore ID univoci
var _idCounter = 0;
function generateUniqueId() {
    return 'gen-' + Date.now() + '-' + (_idCounter++);
}


/* ============================================================
   ZONE SVG ↔ RIGHE DI TESTO — click per evidenziare
   ============================================================ */
function setupZoneHighlighting() {
    $('svg rect').css('pointer-events', 'auto');

    // Click su un rettangolo SVG → evidenzia la riga di testo corrispondente
    $(document).on('click', 'svg rect', function (e) {
        e.stopPropagation();
        var rectClass = $(this).attr('class');
        if (!rectClass || rectClass === 'selected') return;

        // La classe del rect coincide con l'id della riga (senza #)
        var targetEl = findElementById(rectClass);
        if (targetEl.length) {
            clearHighlights();
            $(this).addClass('selected');
            targetEl.addClass('highlight-text');
            scrollToElement(targetEl);
        }
    });

    // Click su una riga di testo → evidenzia il rettangolo SVG corrispondente
    $(document).on('click', '.text-line, .fw, .article-title, .column-break, .page-break', function (e) {
        // Non intercettare click su link o note
        if ($(e.target).closest('.note-ref, .entity-link').length) return;
        var elementId = $(this).attr('id');
        if (!elementId) return;

        var rect = findRectByClass(elementId);
        if (rect.length) {
            clearHighlights();
            $(this).addClass('highlight-text');
            rect.addClass('selected');
            scrollToRect(rect);
        }
    });
}

function clearHighlights() {
    $('svg rect.selected').removeClass('selected');
    $('.highlight-text').removeClass('highlight-text');
}

// Cerca un elemento di testo per id (varie strategie)
function findElementById(id) {
    var el = $('#' + CSS.escape(id));
    if (!el.length) el = $('.text-line[id="' + id + '"]');
    if (!el.length) el = $('[id="' + id + '"]');
    return el;
}

// Cerca un rettangolo SVG per classe (= id della riga)
function findRectByClass(id) {
    // Nel tuo XML il rect ha class uguale all'id del lb (senza #)
    return $('svg rect[class="' + id + '"], svg rect[class*="' + id + '"]').first();
}

// Scorre la colonna testo per rendere visibile l'elemento
function scrollToElement(element) {
    var container = element.closest('.text-column');
    if (!container.length) return;
    var offset = element.offset().top - container.offset().top + container.scrollTop();
    container.animate({ scrollTop: offset }, 250);
}

// Scorre la colonna facsimile per rendere visibile il rettangolo
function scrollToRect(rect) {
    var container = rect.closest('.facsimile-container');
    if (!container.length) return;
    var offset = rect.offset().top - container.offset().top + container.scrollTop();
    container.animate({ scrollTop: offset }, 250);
}


/* ============================================================
   FORM-WORK — fw → text-line con classe di posizione
   ============================================================ */
function setupFormWork() {
    $('.fw').each(function () {
        var fw        = $(this);
        var placeAttr = fw.attr('data-place') || fw.attr('place') || '';
        var placeClass = placeAttr.replace(/\s+/g, '-');
        if (placeClass) fw.addClass(placeClass);
        if (!fw.hasClass('text-line')) fw.addClass('text-line');
    });
}


/* ============================================================
   COLUMN BREAKS — aggiunge classe multi-column al div padre
   ============================================================ */
function setupColumnBreaks() {
    $('.column-break').each(function () {
        $(this).closest('.text-div').removeClass('no-column').addClass('multi-column');
    });
}


/* ============================================================
   REFERENCES — placeholder (estendibile)
   ============================================================ */
function setupReferences() { /* estendibile */ }


/* ============================================================
   ENTITY LINKS — popup per persone, luoghi, termini/glossario
   ============================================================ */
function setupEntityLinks() {
    $(document).on('click', '.entity-link', function (e) {
        e.preventDefault();
        var href = $(this).attr('href');
        if (!href) return;

        // Rimuove il # iniziale per cercare l'elemento
        var targetId = href.replace(/^#/, '');
        var targetEl = $('#' + CSS.escape(targetId));
        if (!targetEl.length) return;

        // Determina il tipo in base alle classi del target
        if (targetEl.hasClass('person-card') || targetEl.closest('.people-section').length) {
            showEntityCard(targetEl, 'person');
        } else if (targetEl.hasClass('person-card') && targetEl.closest('.places-section').length) {
            showEntityCard(targetEl, 'place');
        } else if (targetEl.hasClass('glossary-card') || targetEl.closest('#glossary-section').length) {
            showEntityCard(targetEl, 'glossary');
        } else {
            // Fallback: scroll all'ancora
            $('html, body').scrollTop(targetEl.offset().top - 100);
        }
    });
}

// Crea e mostra il popup con le informazioni dell'entità
function showEntityCard(element, type) {
    if (!element.length) return;

    var title, content, headerClass;

    if (type === 'person' || type === 'place') {
        title       = element.find('h3').first().text();
        content     = element.find('.person-details').html() || '';
        headerClass = type === 'person' ? 'persName' : 'placeName';
    } else {
        title       = element.find('h4').first().text();
        content     = element.find('.glossary-details').html() ||
                      element.find('.definition-info').html() || '';
        headerClass = 'term';
    }

    if (!content) {
        var clone = element.clone();
        clone.find('h3, h4').remove();
        content = clone.html();
    }

    // Rimuove eventuali popup esistenti
    $('.entity-overlay').remove();

    var overlay = $(
        '<div class="entity-overlay">' +
            '<div class="entity-card">' +
                '<div class="entity-card-header ' + headerClass + '">' +
                    '<h3>' + title + '</h3>' +
                    '<button class="entity-card-close" aria-label="Chiudi">&times;</button>' +
                '</div>' +
                '<div class="entity-card-body">' + content + '</div>' +
            '</div>' +
        '</div>'
    );

    // Aggiunge alla main visibile (compatibile con layout a sezioni)
    var mainContainer = $('.visible-section .main, .visible-section main, .visible-section').first();
    if (!mainContainer.length) mainContainer = $('body');
    mainContainer.append(overlay);

    // Chiusura
    overlay.on('click', function (e) {
        if ($(e.target).is('.entity-overlay') || $(e.target).is('.entity-card-close')) {
            overlay.remove();
        }
    });
    // Chiusura con Escape
    $(document).one('keydown.entity-overlay', function (e) {
        if (e.key === 'Escape') overlay.remove();
    });
}


/* ============================================================
   INIZIALIZZAZIONE HIGHLIGHTING — verifica coppie lb-rect
   ============================================================ */
function initializeHighlighting() {
    setTimeout(function () {
        var missing = 0;
        $('.text-line, .fw, .article-title').each(function () {
            var id = $(this).attr('id');
            if (id && !findRectByClass(id).length) missing++;
        });
        if (missing > 0) {
            console.info('[Rassegna] ' + missing + ' righe senza zona facsimile corrispondente.');
        }
    }, 150);
}


/* ============================================================
   RESIZE ZONE SVG — ricalcola dimensioni al resize finestra
   ============================================================ */
function resizeZones() {
    $('.page-facsimile').each(function () {
        var container   = $(this);
        var img         = container.find('.facsimile-image');
        var currentW    = img.width();
        var originalW   = parseInt(img.attr('width')) || 1000;
        var scale       = currentW / originalW;
        var svg         = container.find('svg');

        if (svg.length) {
            var vb = (svg.attr('viewBox') || '').split(',');
            if (vb.length === 4) {
                svg.attr({
                    viewBox: '0,0,' + vb[2] + ',' + vb[3],
                    width:   currentW,
                    height:  img.height()
                });
            }
        }
    });
}

$(window).on('resize', resizeZones);


/* ============================================================
   NOTE POPUP
   ============================================================ */
$(document).ready(function () {

    if (!$('.note-overlay').length) {
        $('body').append('<div class="note-overlay"></div>');
    }

    $(document).on('click', '.note-trigger', function (e) {
        e.stopPropagation();
        var nid = $(this).data('note-id');
        var popup = $('#note-' + nid);
        if (!popup.length) return;
        $('.note-popup.visible').removeClass('visible');
        popup.addClass('visible');
        $('.note-overlay').addClass('visible');
    });

    $(document).on('click', '.note-popup-close', function (e) {
        e.stopPropagation();
        $(this).closest('.note-popup').removeClass('visible');
        $('.note-overlay').removeClass('visible');
    });

    $(document).on('click', '.note-overlay', function () {
        $('.note-popup.visible').removeClass('visible');
        $(this).removeClass('visible');
    });

    $(document).on('keydown', function (e) {
        if (e.key === 'Escape') {
            $('.note-popup.visible').removeClass('visible');
            $('.note-overlay').removeClass('visible');
        }
    });
});