// import modules
import { Edit } from '/modules/edit.mjs'
import { AddElementModal } from '/modules/add-element.mjs'
import { AddPageModal } from '/modules/add-page.mjs'
import { ContentSlider } from '/modules/content-slider.mjs'
import { EditElementModal } from '/modules/edit-element.mjs'
import { EditLayoutModal } from '/modules/edit-layout.mjs'
import { EditFormModal } from '/modules/edit-form.mjs'
import { EditImageModal } from '/modules/edit-image.mjs'
import { EditLinkModal } from '/modules/edit-link.mjs'
import { SelectImageModal } from '/modules/select-image.mjs'
import { SelectFileModal } from '/modules/select-file.mjs'
import { SelectLayout } from '/modules/select-layout.mjs'
import { SelectPageModal } from '/modules/select-page.mjs'
import { EditFormFieldModal } from '/modules/edit-form-field.mjs'
import { EditGalleryModal } from '/modules/edit-gallery.mjs'
import { EditGalleryImageModal } from '/modules/edit-gallery-image.mjs'
import { EditVideoModal } from '/modules/edit-video.mjs'
import { PageSettingsModal } from '/modules/page-settings.mjs'
import { EditMenuModal } from '/modules/edit-menu.mjs'
import { EditMenuItemModal } from '/modules/edit-menu-item.mjs'
import { EditComponentModal } from '/modules/edit-component.mjs'
import { RemovePageModal } from '/modules/remove-page.mjs'

// setup app
let app = {}

app.setup = function() {

    // setup toast
    shared.toast.setup()

    // create objects
    let edit = new Edit(), 
        addElementModal = new AddElementModal(), 
        contentSlider = new ContentSlider(),
        addPageModal = new AddPageModal(),
        editElementModal = new EditElementModal(),
        editLayoutModal = new EditLayoutModal(),
        editFormModal = new EditFormModal(),
        editGalleryModal = new EditGalleryModal(),
        editImageModal = new EditImageModal(),
        editLinkModal = new EditLinkModal(),
        selectImageModal = new SelectImageModal(),
        selectFileModal = new SelectFileModal(),
        selectLayout = new SelectLayout(),
        selectPageModal = new SelectPageModal(),
        editFormFieldModal = new EditFormFieldModal(),
        editGalleryImageModal = new EditGalleryImageModal(),
        editVideo = new EditVideoModal(),
        pageSettingsModal = new PageSettingsModal(),
        editMenuModal = new EditMenuModal(),
        editMenuItemModal = new EditMenuItemModal(),
        editComponentModal = new EditComponentModal(),
        removePageModal = new RemovePageModal()
}

app.setup();

