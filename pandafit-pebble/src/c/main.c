#include <pebble.h>
#include <stdio.h>

#define KEY_IMAGE 0
#define KEY_SCORE 1
  
static Window *s_main_window;

static TextLayer *s_score_layer;

static BitmapLayer *s_icon_layer;
static GBitmap *s_icon_bitmap;
const int animation_frames[5][2] = { 
  { // Ecstatic -> 0
    RESOURCE_ID_ECSTATIC_0,
    RESOURCE_ID_ECSTATIC_1
  },
  { // Happy -> 1
    RESOURCE_ID_HAPPY_0,
    RESOURCE_ID_HAPPY_1 
  },
  { // Content -> 2
    RESOURCE_ID_CONTENT_0,
    RESOURCE_ID_CONTENT_1
  },
  { // Angry -> 3
    RESOURCE_ID_ANGRY_0,
    RESOURCE_ID_ANGRY_1 
  },
  { // Dying -> 4
    RESOURCE_ID_DYING_0,
    RESOURCE_ID_DYING_1
  }

};

int frame_no;
int selected_image = 0;
char* score;
bool image_changed = 0;

static void timer_handler_lol(void *context) {
    if (s_icon_bitmap != NULL) {
      gbitmap_destroy(s_icon_bitmap);
      s_icon_bitmap = NULL;
    }
    if (image_changed){
      frame_no = 0;
      image_changed = 0;
    }
    
    s_icon_bitmap = gbitmap_create_with_resource(animation_frames[selected_image][frame_no]);
    
    bitmap_layer_set_bitmap(s_icon_layer, s_icon_bitmap);
  
    layer_mark_dirty(bitmap_layer_get_layer(s_icon_layer));
  
    frame_no++;
    frame_no %= ARRAY_LENGTH(animation_frames[selected_image]);

    app_timer_register(750, timer_handler_lol, NULL); 
    
};

static void load_sequence() {
  frame_no = 0;
  app_timer_register(1, timer_handler_lol, NULL);
}

 
static void main_window_load(Window *window) {
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Window load!");
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  s_icon_layer = bitmap_layer_create(bounds);
  bitmap_layer_set_compositing_mode(s_icon_layer, GCompOpSet);
  layer_add_child(window_layer, bitmap_layer_get_layer(s_icon_layer));
  
  s_score_layer = text_layer_create(GRect(0, 122, bounds.size.w, 32));
  text_layer_set_text_color(s_score_layer, GColorBlack);
  text_layer_set_background_color(s_score_layer, GColorClear);
  text_layer_set_font(s_score_layer, fonts_get_system_font(FONT_KEY_GOTHIC_28_BOLD));
  text_layer_set_text_alignment(s_score_layer, GTextAlignmentLeft);
  layer_add_child(window_layer, text_layer_get_layer(s_score_layer));
  
  load_sequence();

  APP_LOG(APP_LOG_LEVEL_DEBUG, "Finished window load!");
}
 
static void main_window_unload(Window *window) {
  gbitmap_destroy(s_icon_bitmap);
  bitmap_layer_destroy(s_icon_layer);
}
 
static void tick_handler(struct tm *tick_time, TimeUnits units_changed) {
  //load_sequence();
  // Get update every 7 seconds
  if(tick_time->tm_sec % 2 == 0) {
    // Begin dictionary
    DictionaryIterator *iter;
    app_message_outbox_begin(&iter);
 
    // Add a key-value pair
    dict_write_uint8(iter, 0, 0);
 
    // Send the message!
    app_message_outbox_send();
  }
}
 
static void inbox_received_callback(DictionaryIterator *iterator, void *context) {
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Got message, iterating..");
  Tuple* current = dict_read_first(iterator);
  while(current){
    APP_LOG(APP_LOG_LEVEL_DEBUG, "Current key is %lu", (unsigned long)current->key);
    
    if(current->key == KEY_IMAGE) {
      APP_LOG(APP_LOG_LEVEL_DEBUG, "Showing image %lu!", (unsigned long)current->value->uint8);
      selected_image = current->value->int32;
    }
  
    if(current->key == KEY_SCORE){
      // score = score_tuple->value->int32;
      APP_LOG(APP_LOG_LEVEL_DEBUG, "Got score %s!", current->value->cstring);
      // memcpy(score, score_tuple->value->cstring, score_tuple->length);
      text_layer_set_text(s_score_layer, current->value->cstring);
      APP_LOG(APP_LOG_LEVEL_DEBUG, "Set text");
    }
    current = dict_read_next(iterator);
  }
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Done iterating.");
  // If all data is available, use it
}
 
static void inbox_dropped_callback(AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Message dropped!");
}
 
static void outbox_failed_callback(DictionaryIterator *iterator, AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Outbox send failed!");
}
 
static void outbox_sent_callback(DictionaryIterator *iterator, void *context) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Outbox send success!");
}
  
static void init() {
  // Create main Window element and assign to pointer
  s_main_window = window_create();
  window_set_background_color(s_main_window, GColorBlack);
  window_set_window_handlers(s_main_window, (WindowHandlers) {
    .load = main_window_load,
    .unload = main_window_unload
  });
  window_stack_push(s_main_window, true);
  
  // Register with TickTimerService
  tick_timer_service_subscribe(SECOND_UNIT, tick_handler);
  
  // Register callbacks
  app_message_register_inbox_received(inbox_received_callback);
  app_message_register_inbox_dropped(inbox_dropped_callback);
  app_message_register_outbox_failed(outbox_failed_callback);
  app_message_register_outbox_sent(outbox_sent_callback);
  
  // Open AppMessage
  const int inbox_size = 128;
  const int outbox_size = 128;
  app_message_open(inbox_size, outbox_size);
}
 
static void deinit() {
  // Destroy Window
  window_destroy(s_main_window);
}
 
int main(void) {
  init();
  app_event_loop();
  deinit();
}