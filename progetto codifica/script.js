var ID_ALIASES = {
    'SNF': 'SNF_org'
};

$(document).ready(function () {
    initializeNavigation();
    setupTextLines();
    initializeHighlighting();
    setupZoneHighlighting();
    setupFormWork();
    setupReferences();
    setupEntityLinks();
    setupColumnBreaks();
    setupNotePopups();

    // Smooth scroll per link anchor (esclusi entity-link e note-ref)
    $('a[href^="#"]').not('.entity-link, .note-ref').on('click', function (e) {
        e.preventDefault();
        var target = $(this.hash);
        if (target.length) {
            $('html, body').scrollTop(target.offset().top - 70);
        }
    });

    // Ricalcola le zone SVG dopo il caricamento immagini
    setTimeout(resizeZones, 300);
    $(window).on('load', function () { resizeZones(); });
});


/* ============================================================
   NAVIGAZIONE
   ============================================================ */
function initializeNavigation() {

    // Vecchia tendina (retrocompatibilità)
    $('#navigation-fab button').on('click', function (e) {
        $('.navigation-dropdown').toggleClass('active');
        e.stopPropagation();
    });
    $('.navigation-dropdown').on('click', function (e) { e.stopPropagation(); });

    // Navbar orizzontale: apri/chiudi dropdown
    $(document).on('click', '.dropdown-toggle', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var item = $(this).closest('.nav-item');
        var isOpen = item.hasClass('open');
        $('.nav-item').removeClass('open');
        if (!isOpen) item.addClass('open');
    });

    // Click su qualsiasi link di navigazione
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

    // Click sul logo/brand
    $(document).on('click', '.nav-logo, .navbar-brand', function (e) {
        e.preventDefault();
        $('.nav-item').removeClass('open');
        showSection('#info-section');
        $('html, body').scrollTop(0);
    });

    // Pulsanti avanti/indietro (se presenti)
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
    var infoAnchors = [
        '#document-info', '#people-section', '#places-section',
        '#organisations-section', '#glossary-section',
        '#glossario_norme', '#glossario_licenze', '#glossario_pedagogia',
        '#glossario_discipline', '#glossario_politica',
        '#glossario_salute', '#glossario_periodici', '#info-section'
    ];
    if (infoAnchors.indexOf(href) !== -1) {
        showSection('#info-section');
        if (href !== '#info-section') {
            setTimeout(function () {
                setTimeout(function () {
                    var t = $(href);
                    if (t.length) {
                        $('html, body').animate({ scrollTop: t.offset().top - 70 }, 300);
                    }
                }, 50);
            }, 250);
        }
    } else {
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

// Chiude dropdown cliccando fuori
$(document).on('click', function () {
    $('.navigation-dropdown').removeClass('active');
    $('.nav-item').removeClass('open');
});


/* ============================================================
   RIGHE DI TESTO
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

    $('.column-break, .page-break').each(function () {
        if (!$(this).hasClass('text-line')) $(this).addClass('text-line');
    });

    $('.fw').each(function () {
        if (!$(this).hasClass('text-line') && !$(this).hasClass('processed-lines')) {
            $(this).addClass('text-line processed-lines');
        }
    });
}

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

    var parts = tempContainer.html().split(/<span class="line-marker"[^>]*><\/span>/);
    container.empty();

    parts.forEach(function (part, index) {
        if (!part.trim()) return;
        var lbMatch = part.match(/<(?:lb|span[^>]*class="line-break"[^>]*)\s+id="([^"]+)"/);
        var lineId  = lbMatch ? lbMatch[1] : (containerId + '-line-' + (index + 1));
        var clean   = part.replace(/<lb[^>]*>|<span[^>]*class="line-break"[^>]*><\/span>/g, '');
        container.append($('<div class="text-line" id="' + lineId + '">' + clean + '</div>'));
    });

    container.removeClass('text-paragraph list-item');
    return lineNumber - 1;
}

var _idCounter = 0;
function generateUniqueId() {
    return 'gen-' + Date.now() + '-' + (_idCounter++);
}


/* ============================================================
   ZONE SVG ↔ RIGHE DI TESTO
   ============================================================ */
function setupZoneHighlighting() {
    $('svg rect').css('pointer-events', 'auto');

    // Click zona SVG → evidenzia riga testo
    $(document).on('click', 'svg rect', function (e) {
        e.stopPropagation();
        var rectClass = $(this).attr('class');
        if (!rectClass || rectClass === 'selected') return;
        var targetEl = findElementById(rectClass);
        if (targetEl.length) {
            clearHighlights();
            $(this).addClass('selected');
            targetEl.addClass('highlight-text');
            scrollToElement(targetEl);
        }
    });

    // Click riga testo → evidenzia zona SVG
    $(document).on('click', '.text-line, .fw, .article-title, .column-break, .page-break', function (e) {
        if ($(e.target).closest('.note-ref, .entity-link, .entity').length) return;
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

function findElementById(id) {
    var el = $('#' + CSS.escape(id));
    if (!el.length) el = $('.text-line[id="' + id + '"]');
    if (!el.length) el = $('[id="' + id + '"]');
    return el;
}

function findRectByClass(id) {
    return $('svg rect[class="' + id + '"], svg rect[class*="' + id + '"]').first();
}

function scrollToElement(element) {
    var container = element.closest('.text-column');
    if (!container.length) return;
    var offset = element.offset().top - container.offset().top + container.scrollTop();
    container.animate({ scrollTop: offset }, 250);
}

function scrollToRect(rect) {
    var container = rect.closest('.facsimile-container');
    if (!container.length) return;
    var offset = rect.offset().top - container.offset().top + container.scrollTop();
    container.animate({ scrollTop: offset }, 250);
}


function setupFormWork() {
    $('.fw').each(function () {
        var fw         = $(this);
        var placeAttr  = fw.attr('data-place') || fw.attr('place') || '';
        var placeClass = placeAttr.replace(/\s+/g, '-');
        if (placeClass) fw.addClass(placeClass);
        if (!fw.hasClass('text-line')) fw.addClass('text-line');
    });
}


function setupColumnBreaks() {
    $('.column-break').each(function () {
        $(this).closest('.text-div').removeClass('no-column').addClass('multi-column');
    });
}

function setupReferences() { /* estendibile */ }


/* ============================================================
   ENTITY LINKS — popup per persone, luoghi, termini/glossario
   ============================================================ */
function setupEntityLinks() {

    $(document).on('click', '.entity-link, span.entity, span.entity-term', function (e) {
        e.preventDefault();
        e.stopPropagation();

        var href = $(this).attr('href') ||
                   $(this).find('a.entity-link').first().attr('href');
        if (!href || href === '#') return;

        var rawId;
        try { rawId = decodeURIComponent(href.replace(/^#/, '')); }
        catch(ex) { rawId = href.replace(/^#/, ''); }

        var targetId = ID_ALIASES[rawId] || rawId;

        var targetEl = $('#' + CSS.escape(targetId));
        if (!targetEl.length) targetEl = $('[id="' + targetId + '"]');

        if (!targetEl.length) {
            console.warn('[Rassegna] Entità non trovata nel DOM: #' + targetId);
            return;
        }

        var type;
        if (targetEl.hasClass('person-card') && targetEl.closest('.places-section, #places-section').length) {
            type = 'place';
        } else if (targetEl.hasClass('person-card')) {
            type = 'person';
        } else if (targetEl.hasClass('org-card')) {
            type = 'org';
        } else if (targetEl.hasClass('glossary-card') || targetEl.closest('#glossary-section, .glossary-section').length) {
            type = 'glossary';
        } else {
            var section = targetEl.closest('.article-section, #info-section');
            if (section.length && !section.hasClass('visible-section')) {
                showSection('#' + section.attr('id'));
            }
            setTimeout(function () {
                $('html, body').animate({ scrollTop: targetEl.offset().top - 80 }, 300);
            }, 150);
            return;
        }

        var $span = $(this).is('span') ? $(this) : $(this).closest('span.entity, span.entity-term, span.term');
        if (!$span.length) $span = $(this).parents('span[style*="background"]').first();
        var clickedBg = $span.css('background-color');
        showEntityCard(targetEl, type, darkenColor(clickedBg));
    });
}

function darkenColor(rgbString) {
    if (!rgbString) return '';
    var match = rgbString.match(/rgb\((\d+),\s*(\d+),\s*(\d+)\)/);
    if (!match) return rgbString;
    var r = Math.max(0, Math.round(parseInt(match[1]) * 0.55));
    var g = Math.max(0, Math.round(parseInt(match[2]) * 0.55));
    var b = Math.max(0, Math.round(parseInt(match[3]) * 0.55));
    return 'rgb(' + r + ',' + g + ',' + b + ')';
}

function showEntityCard(element, type, bgColor) {
    if (!element.length) return;

    var title, content, headerClass;

    if (type === 'person') {
        title       = element.find('h3').first().text().trim();
        content     = element.find('.person-details').html() || '';
        headerClass = 'persName';
    } else if (type === 'place') {
        title       = element.find('h3').first().text().trim();
        content     = element.find('.person-details').html() || '';
        headerClass = 'placeName';
    } else {
        title       = element.find('h4').first().text().trim();
        content     = element.find('.glossary-details').html() ||
                      element.find('.definition-info').html() || '';
        headerClass = 'term';
    }

    if (!content || !content.trim()) {
        var clone = element.clone();
        clone.find('h3, h4').remove();
        content = clone.html().trim();
    }

    if (!title) title = '—';

    $('.entity-overlay').remove();

    var overlay = $(
        '<div class="entity-overlay" role="dialog" aria-modal="true">' +
            '<div class="entity-card">' +
                '<div class="entity-card-header ' + headerClass + '" style="' + (bgColor ? 'background:' + bgColor + ';' : '') + '">' +
                    '<h3>' + title + '</h3>' +
                    '<button class="entity-card-close" aria-label="Chiudi">&times;</button>' +
                '</div>' +
                '<div class="entity-card-body">' + content + '</div>' +
            '</div>' +
        '</div>'
    );

    var mainContainer = $('.visible-section').first();
    if (!mainContainer.length) mainContainer = $('body');
    mainContainer.append(overlay);

    overlay.on('click', function (e) {
        if ($(e.target).is('.entity-overlay') || $(e.target).is('.entity-card-close')) {
            overlay.remove();
            $(document).off('keydown.entity-overlay');
        }
    });

    $(document).on('keydown.entity-overlay', function (e) {
        if (e.key === 'Escape') {
            overlay.remove();
            $(document).off('keydown.entity-overlay');
        }
    });
}


/* ============================================================
   HIGHLIGHTING — verifica coppie lb-rect
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
   RESIZE ZONE SVG
   ============================================================ */
function resizeZones() {
    $('.page-facsimile').each(function () {
        var container = $(this);
        var img       = container.find('.facsimile-image');
        var currentW  = img.width();
        var svg       = container.find('svg');
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
function setupNotePopups() {

    if (!$('.note-overlay').length) {
        $('body').append('<div class="note-overlay"></div>');
    }

    $(document).on('click', '.note-trigger', function (e) {
        e.stopPropagation();
        var nid   = $(this).data('note-id');
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
            $('.entity-overlay').remove();
        }
    });
}